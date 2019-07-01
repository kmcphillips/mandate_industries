# frozen_string_literal: true
module Twilio
  module Phone
    class BaseTree
      class << self
        def voice(voice_name)
          tree.config[:voice] = voice_name
          nil
        end

        def greeting(message: nil, prompt:)
          tree.greeting = Twilio::Phone::Tree::After.new(message: message, prompt: prompt)
          nil
        end

        def prompt(prompt_name, message:, gather:, after:)
          tree.prompts[prompt_name] = Twilio::Phone::Tree::Prompt.new(name: prompt_name, message: message, gather: gather, after: after)
          nil
        end

        def tree_name
          self.name.demodulize.underscore.sub(/_tree\z/, "")
        end

        def tree
          @tree ||= Twilio::Phone::Tree.new(tree_name)
        end
      end
    end
  end
end
