class Twilio::PhoneRespondErrorOperation < ApplicationOperation
  def execute
    twiml = Twilio::TwiML::VoiceResponse.new
    twiml.hangup
    twiml.to_s
  end
end
