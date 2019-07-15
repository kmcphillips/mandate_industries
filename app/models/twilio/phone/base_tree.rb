# frozen_string_literal: true
module Twilio
  module Phone
    class BaseTree
      class << self
        def voice(voice_name)
          tree.config[:voice] = voice_name
          nil
        end

        def timeout_message(message)
          tree.config[:timeout_message] = message
          nil
        end

        def greeting(message: nil, play: nil, prompt:)
          tree.greeting = Twilio::Phone::Tree::After.new(message: message, play: play, prompt: prompt)
          nil
        end

        def prompt(prompt_name, message: nil, play: nil, gather: nil, after:)
          tree.prompts[prompt_name] = Twilio::Phone::Tree::Prompt.new(name: prompt_name, message: message, play: play, gather: gather, after: after)
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
