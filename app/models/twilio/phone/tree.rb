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
        @config[:timeout_message] = nil
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
              @args[:profanity_filter] = false unless @args.key?(:profanity_filter)
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
