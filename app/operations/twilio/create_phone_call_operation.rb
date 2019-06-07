# frozen_string_literal: true
module Twilio
  class CreatePhoneCallOperation < ApplicationOperation
    input :params, accepts: Hash, type: :keyword, required: true

    def execute
      phone_call = PhoneCall.new(
        sid: params["CallSid"],
        number: params["Called"].presence || params["To"].presence,
        caller_number: params["Caller"] || params["From"].presence,
        caller_city: params["CallerCity"] || params["FromCity"].presence,
        caller_province: params["CallerState"] || params["FromState"].presence,
        caller_country: params["CallerCountry"] || params["FromCountry"].presence,
      )
      phone_call.save!

      Rails.logger.tagged(self.class) { |l| l.info("created #{phone_call.inspect}") }

      phone_call
    end
  end
end
