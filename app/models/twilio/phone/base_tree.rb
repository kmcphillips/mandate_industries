# frozen_string_literal: true
module Twilio
  module Phone
    class BaseTree
      class << self
        def voice(&block)
          tree.config[:voice] = yield
          nil
        end

        def timeout_message(&block)
          raise ArgumentError unless block_given?
          tree.config[:timeout_message] = block
          nil
        end

        def greeting(&block)
          context = AfterContext.new
          context.instance_eval(&block)
          tree.greeting = Twilio::Phone::Tree::After.new(**context.args)
          nil
        end

        def prompt(prompt_name, &block)
          context = PromptContext.new
          context.instance_eval(&block)
          tree.prompts[prompt_name] = Twilio::Phone::Tree::Prompt.new(**context.args.merge(name: prompt_name))
          nil
        end

        def tree_name
          self.name.demodulize.underscore.sub(/_tree\z/, "")
        end

        def tree
          @tree ||= Twilio::Phone::Tree.new(tree_name)
        end
      end

      class AfterContext
        attr_reader :args

        def initialize
          @args = {
            message: nil,
            prompt: nil,
            hangup: nil,
          }
        end

        def message(val=nil, &block)
          @args[:message] = val || block
          nil
        end

        def prompt(val)
          @args[:prompt] = val
          nil
        end

        def hangup
          @args[:hangup] = true
        end
      end

      class PromptContext
        attr_reader :args

        def initialize
          @args = {
            message: nil,
            gather: nil,
            after: nil,
          }
        end

        def message(val=nil, &block)
          @args[:message] = val || block
          nil
        end

        def gather(gather_args)
          @args[:gather] = gather_args
          nil
        end

        def after(&block)
          context = AfterContext.new
          context.instance_eval(&block)
          @args[:after] = context.args
          nil
        end
      end
    end
  end
end
