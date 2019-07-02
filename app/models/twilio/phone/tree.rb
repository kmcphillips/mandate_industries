# frozen_string_literal: true
module Twilio
  module Phone
    class Tree
      class InvalidError < StandardError ; end

      attr_reader :name, :prompts, :config
      attr_accessor :greeting

      class << self
        def register(tree_name, tree)
          trees[tree_name] = tree
        end

        def for(tree_name)
          trees[tree_name] || raise(Twilio::Phone::Tree::InvalidError, "tree #{tree_name} not found")
        end

        private

        def trees
          @trees ||= {}.with_indifferent_access
        end
      end

      def initialize(tree_name)
        @name = tree_name.to_s
        raise Twilio::Phone::Tree::InvalidError, "tree name cannot be blank" unless name.present?
        self.class.register(name, self)

        @prompts = {}.with_indifferent_access
        @config = {}.with_indifferent_access

        # defaults
        @config[:voice] = "male"
      end

      def greeting_twiml(phone_call, after=nil)
        after ||= greeting
        response = phone_call.responses.create!(prompt_handle: after.prompt)

        Twilio::TwiML::VoiceResponse.new do |twiml|
          twiml.say(voice: config[:voice], message: after.message) if after.message.present?
          if after.hangup?
            twiml.hangup
          else
            twiml.redirect("/twilio/phone/#{name}/prompt/#{response.id}")
          end
        end.to_s
      end

      def prompt_twiml(phone_call, response_id)
        response = phone_call.responses.find(response_id)
        prompt = prompts[response.prompt_handle]

        Twilio::TwiML::VoiceResponse.new do |twiml|
          twiml.say(voice: config[:voice], message: greeting.message) if greeting.message.present?
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
            twiml.record(
              max_length: prompt.gather.args[:length],
              play_beep: prompt.gather.args[:beep],
              # trim: "trim-silence",
              action: "/twilio/phone/#{name}/prompt_response/#{response.id}.xml",
              recording_status_callback: "/twilio/phone/receive_recording/#{response.id}",
            )
          else
            raise Twilio::Phone::Tree::InvalidError, "unknown gather type #{prompt.gather.type.inspect}"
          end
          # TODO timeout and continue
        end.to_s
      end

      def prompt_response_twiml(phone_call, response_id, params_hash)
        response = phone_call.responses.find(response_id)
        prompt = prompts[response.prompt_handle]

        Twilio::PhonePromptUpdateResponseOperation.call(params: params_hash, response_id: response.id)

        greeting_twiml(phone_call, prompt.after)
      end

      class Prompt
        attr_reader :name, :message, :gather, :after

        def initialize(name:, message:, gather:, after:)
          @name = name&.to_sym
          raise Twilio::Phone::Tree::InvalidError, "prompt name cannot be blank" if @name.blank?

          @message = message.presence
          raise Twilio::Phone::Tree::InvalidError, "message must be a string" if @message && !@message.is_a?(String)

          @gather = Twilio::Phone::Tree::Gather.new(gather)
          @after = Twilio::Phone::Tree::After.new(after)
        end
      end

      class After
        attr_reader :message, :prompt

        def initialize(args)
          case args
          when Symbol, String
            @prompt = args.to_sym
          when Proc
            @proc = args
          when Hash
            args = args.with_indifferent_access
            @prompt = args[:prompt]&.to_sym
            @message = args[:message]
            @hangup = !!args[:hangup]

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
