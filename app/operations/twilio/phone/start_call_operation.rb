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

        Twilio::Phone::CreateOperation.call(params: params, tree: tree)
      end
    end
  end
end
