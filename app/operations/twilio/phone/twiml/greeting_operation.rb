# frozen_string_literal: true
module Twilio
  module Phone
    module Twiml
      class GreetingOperation < Twilio::Phone::BaseOperation
        input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true

        def execute
          after = tree.greeting
          after = Twilio::Phone::Tree::After.new(after.proc.call(nil)) if after.proc
          Twilio::Phone::Twiml::AfterOperation.call(phone_call_id: phone_call.id, tree: tree, after: after)
        end
      end
    end
  end
end
