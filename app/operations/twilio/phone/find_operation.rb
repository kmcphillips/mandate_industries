# frozen_string_literal: trueapp/operations/twilio/find_phone_call_operation.rb
module Twilio
  module Phone
    class FindOperation < ApplicationOperation
      input :params, accepts: Hash, type: :keyword, required: true

      def execute
        PhoneCall.find_by!(sid: params["CallSid"])
      end
    end
  end
end
