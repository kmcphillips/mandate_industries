# frozen_string_literal: true
module Twilio
  module SMS
    class BaseTree
      class << self
        # TODO
        def prompt(prompt_name, message:, after:)
          tree.prompts[prompt_name] = Twilio::SMS::Tree::Prompt.new(name: prompt_name, message: message, after: after)
          nil
        end

        def tree_name
          self.name.demodulize.underscore.sub(/_tree\z/, "")
        end

        def tree
          @tree ||= Twilio::SMS::Tree.new(tree_name)
        end
      end
    end
  end
end
