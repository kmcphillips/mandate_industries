# frozen_string_literal: true
module Twilio
  class AnswerOperation < Twilio::BaseOperation
    def execute
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(message: "Hello, and thank you for calling Mandate Industries Incorporated! Goodbye.")
      end

      response.to_s
    end
  end
end
