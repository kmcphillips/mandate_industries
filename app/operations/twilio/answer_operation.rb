# frozen_string_literal: true
module Twilio
  class AnswerOperation < ApplicationOperation
    input :params, accepts: Hash, type: :keyword, required: true

    before do
      halt(hangup_response) unless valid_webhook?
    end

    def execute
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(message: "Hello, and thank you for calling Mandate Industries Incorporated! Goodbye.")
      end

      response.to_s
    end

    private

    def hangup_response
      response = Twilio::TwiML::VoiceResponse.new
      response.hangup
      response.to_s
    end

    def valid_webhook?
      params["AccountSid"] == Rails.application.credentials.twilio![:account_sid]
    end
  end
end
