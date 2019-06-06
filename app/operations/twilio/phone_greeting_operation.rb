# frozen_string_literal: true
module Twilio
  class PhoneGreetingOperation < Twilio::BaseOperation
    def execute
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(voice: "alice", language: "en-CA", message: "Hello, and thank you for calling Mandate Industries Incorporated! Please enter your favorite number.")
        response.gather(action: "/twilio/phone/survey_answer.xml", input: "dtmf", num_digits: 1)
      end

      response.to_s
    end
  end
end
