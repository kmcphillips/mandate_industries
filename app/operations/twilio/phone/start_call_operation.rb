# frozen_string_literal: trueapp/operations/twilio/find_phone_call_operation.rb
module Twilio
  module Phone
    class StartCallOperation < ApplicationOperation
      input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true
      input :to, accepts: String, type: :keyword, required: true

      def execute
        sid = TwilioClient.start_call(tree: tree, to: to)
        params = {
          "CallSid" => sid,
          "direction" => "sent",
          "To" => to,
          "From" => Rails.application.credentials.twilio![:phone_number],
        }

        phone_call = Twilio::Phone::CreateOperation.call(params: params, tree: tree)

        # TODO: This is copied from GreetingOperation and AfterOperation
        after = tree.greeting
        after = Twilio::Phone::Tree::After.new(after.proc.call(nil)) if after.proc
        next_response = phone_call.responses.build(prompt_handle: after.prompt)
        next_response.save! && observer(next_response).notify

        phone_call
      end
    end
  end
end
