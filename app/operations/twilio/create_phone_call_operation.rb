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

      send_notifications

      PhoneCallChannel.broadcast_recent

      phone_call
    end

    private

    def twilio_client
      @twilio_client ||= Twilio::REST::Client.new(
        Rails.application.credentials.twilio![:account_sid],
        Rails.application.credentials.twilio![:auth_token],
      )
    end

    def send_notifications
      Rails.application.credentials.notification_numbers.each do |number|
        twilio_client.messages.create(
          from: Rails.application.credentials.twilio![:phone_number],
          body: "A new call has come into Mandate Industries. https://mandate.kev.cool/",
          to: number,
        )
      end
    end
  end
end
