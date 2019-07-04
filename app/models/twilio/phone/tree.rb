# frozen_string_literal: true
module Twilio
  module Phone
    class Tree
      class InvalidError < StandardError ; end

      attr_reader :name, :prompts, :config
      attr_accessor :greeting

      TREES = {
        favourite_number: "Twilio::Phone::FavouriteNumberTree",
        storytime: "Twilio::Phone::StorytimeTree",
      }.freeze

      class << self
        def for(tree_name)
          trees[tree_name] ||= TREES[tree_name&.to_sym].constantize.tree
        end

        private

        def trees
          @trees ||= {}.with_indifferent_access
        end
      end

      def initialize(tree_name)
        @name = tree_name.to_s
        raise Twilio::Phone::Tree::InvalidError, "tree name cannot be blank" unless name.present?

        @prompts = {}.with_indifferent_access
        @config = {}.with_indifferent_access

        # defaults
        @config[:voice] = "male"
      end

      def greeting_twiml(phone_call)
        after_twiml(phone_call, greeting, nil)
      end

      def prompt_twiml(phone_call, response_id)
        response = phone_call.responses.find(response_id)
        prompt = prompts[response.prompt_handle]

        twiml_response = Twilio::TwiML::VoiceResponse.new do |twiml|
          if prompt.message.present?
            message = prompt.message
            message = message.call(response) if message.is_a?(Proc)
            twiml.say(voice: config[:voice], message: message)
          end

          case prompt.gather.type
          when :digits
            twiml.gather(
              action: "/twilio/phone/#{name}/prompt_response/#{response.id}.xml",
              input: "dtmf",
              num_digits: prompt.gather.args[:number],
              timeout: prompt.gather.args[:timeout],
              action_on_empty_result: false
            )
          when :voice
            args = {
              max_length: prompt.gather.args[:length],
              play_beep: prompt.gather.args[:beep],
              # trim: "trim-silence",
              action: "/twilio/phone/#{name}/prompt_response/#{response.id}.xml",
              recording_status_callback: "/twilio/phone/receive_recording/#{response.id}",
            }

            if prompt.gather.args[:transcribe]
              args[:transcribe] = true
              args[:transcribe_callback] = "/twilio/phone/transcribe/#{response.id}"
            end

            twiml.record(args)
          else
            raise Twilio::Phone::Tree::InvalidError, "unknown gather type #{prompt.gather.type.inspect}"
          end
          # TODO timeout and continue
        end

        Rails.logger.info("prompt_twiml: #{twiml_response.to_s}")
        twiml_response.to_s
      end

      def prompt_response_twiml(phone_call, response_id, params_hash)
        response = phone_call.responses.find(response_id)
        prompt = prompts[response.prompt_handle]

        Twilio::Phone::UpdateResponseOperation.call(params: params_hash, response_id: response.id, phone_call_id: phone_call.id)

        after_twiml(phone_call, prompt.after, response.reload)
      end

      private

      def after_twiml(phone_call, after, previous_response)
        after = Twilio::Phone::Tree::After.new(after.proc.call(previous_response)) if after.proc

        response = phone_call.responses.create!(prompt_handle: after.prompt) unless after.hangup?

        twiml_response = Twilio::TwiML::VoiceResponse.new do |twiml|
          if after.message.present?
            message = after.message
            message = message.call(response) if message.is_a?(Proc)
            twiml.say(voice: config[:voice], message: message)
          end

          if after.hangup?
            twiml.hangup
          else
            twiml.redirect("/twilio/phone/#{name}/prompt/#{response.id}.xml")
          end
        end

        Rails.logger.info("after_twiml: #{twiml_response.to_s}")
        twiml_response.to_s
      end

      class Prompt
        attr_reader :name, :message, :gather, :after

        def initialize(name:, message:, gather:, after:)
          @name = name&.to_sym
          raise Twilio::Phone::Tree::InvalidError, "prompt name cannot be blank" if @name.blank?

          @message = message.presence
          raise Twilio::Phone::Tree::InvalidError, "message must be a string or proc" if @message && !(@message.is_a?(String) || @message.is_a?(Proc))

          @gather = Twilio::Phone::Tree::Gather.new(gather)
          @after = Twilio::Phone::Tree::After.new(after)
        end
      end

      class After
        attr_reader :message, :prompt, :proc

        def initialize(args)
          case args
          when Symbol, String
            @prompt = args.to_sym
          when Proc
            @proc = args
          when Hash
            args = args.with_indifferent_access
            @prompt = args[:prompt]&.to_sym
            @hangup = !!args[:hangup]

            @message = args[:message]
            raise Twilio::Phone::Tree::InvalidError, "message must be a string or proc" if @message && !(@message.is_a?(String) || @message.is_a?(Proc))

            raise Twilio::Phone::Tree::InvalidError, "cannot have both prompt: and hangup:" if @prompt && @hangup
            raise Twilio::Phone::Tree::InvalidError, "must have either prompt: or hangup:" unless @prompt || @hangup
          else
            raise Twilio::Phone::Tree::InvalidError, "cannot parse :after from #{args.inspect}"
          end
        end

        def hangup?
          !!@hangup
        end
      end

      class Gather
        attr_reader :type, :args

        def initialize(args)
          case args
          when Proc
            @proc = args
          when Hash
            @args = args.with_indifferent_access
            @type = @args.delete(:type)&.to_sym

            raise Twilio::Phone::Tree::InvalidError, "gather :type must be :digits or :voice but was #{@type.inspect}" unless [:digits, :voice].include?(@type)

            if digits?
              @args[:timeout] ||= 5
              @args[:number] ||= 1
            elsif voice?
              @args[:length] ||= 10
              @args[:beep] = true unless @args.key?(:beep)
              @args[:transcribe] = false unless @args.key?(:transcribe)
            end
          else
            raise Twilio::Phone::Tree::InvalidError, "cannot parse :gather from #{args.inspect}"
          end
        end

        def digits?
          type == :digits
        end

        def voice?
          type == :voice
        end
      end
    end
  end
end
