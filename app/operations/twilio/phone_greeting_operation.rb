# frozen_string_literal: true
module Twilio
  class PhoneGreetingOperation < Twilio::BaseOperation
    def execute
      @call = Call.new(
        sid: params["CallSid"],
        number: params["Called"].presence || params["To"].presence,
        caller_number: params["Caller"] || params["From"].presence,
        caller_city: params["CallerCity"] || params["FromCity"].presence,
        caller_province: params["CallerState"] || params["FromState"].presence,
        caller_country: params["CallerCountry"] || params["FromCountry"].presence,
      )
      @call.save!

      Rails.logger.tagged(self.class) { |l| l.info("created call #{@call.inspect}") }

      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(voice: voice, message: "Hello, and thank you for calling Mandate Industries Incorporated! Please enter your favorite number.")
        response.gather(action: "/twilio/phone/survey_answer.xml", input: "dtmf", num_digits: 1)
      end

      response.to_s
    end
  end
end
