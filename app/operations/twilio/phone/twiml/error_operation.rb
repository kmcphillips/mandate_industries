# frozen_string_literal: true
class Twilio::Phone::Twiml::ErrorOperation < ApplicationOperation
  def execute
    twiml = Twilio::TwiML::VoiceResponse.new
    twiml.hangup
    twiml.to_s
  end
end
