# frozen_string_literal: true
module Twilio
  class BaseOperation < ApplicationOperation
    input :params, accepts: Hash, type: :keyword, required: true

    before do
      halt(hangup_response) unless valid_webhook?
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

    def voice
      "male"
    end
  end
end
