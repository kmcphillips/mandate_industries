# frozen_string_literal: true
module Twilio
  module Phone
    class CreateOperation < ApplicationOperation
      input :params, accepts: Hash, type: :keyword, required: true
      input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true

      def execute
        phone_call = PhoneCall.new(
          sid: params["CallSid"],
          tree_name: tree.name,
          number: params["Called"].presence || params["To"].presence,
          from_number: params["Caller"].presence || params["From"].presence,
          from_city: params["CallerCity"].presence || params["FromCity"].presence,
          from_province: params["CallerState"].presence || params["FromState"].presence,
          from_country: params["CallerCountry"].presence || params["FromCountry"].presence,
        )
        phone_call.save! && observer(phone_call).notify

        phone_call
      end
    end
  end
end
