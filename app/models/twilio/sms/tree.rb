# frozen_string_literal: true
module Twilio
  module SMS
    class Tree
      attr_reader :name, :prompts, :config

      TREES = {
        cat_facts: "Twilio::SMS::CatFactsTree",
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
        raise Twilio::InvalidTreeError, "tree name cannot be blank" unless name.present?

        @prompts = {}.with_indifferent_access
        @config = {}.with_indifferent_access

        # defaults
        # @config[:todo] = TODO
      end

      class Prompt
        attr_reader :name, :message, :after

        def initialize(name:, message:, after:)
          @name = name&.to_sym
          raise Twilio::InvalidTreeError, "prompt name cannot be blank" if @name.blank?

          @message = message.presence
          raise Twilio::InvalidTreeError, "message must be a string or proc" if @message && !(@message.is_a?(String) || @message.is_a?(Proc))

          @after = Twilio::SMS::Tree::After.new(after)
        end
      end

      class After
        attr_reader :message, :prompt, :proc

        def initialize(args)
          # TODO
          case args
          when Symbol, String
            @prompt = args.to_sym
          when Proc
            @proc = args
          when Hash
            args = args.with_indifferent_access
            @prompt = args[:prompt]&.to_sym
            @message = args[:message]
            raise Twilio::InvalidTreeError, "message must be a string or proc" if @message && !(@message.is_a?(String) || @message.is_a?(Proc))
          else
            raise Twilio::InvalidTreeError, "cannot parse :after from #{args.inspect}"
          end
        end
      end
    end
  end
end
