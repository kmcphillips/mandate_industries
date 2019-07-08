# frozen_string_literal: true
class Twilio::SMS::Twiml::ErrorOperation < ApplicationOperation
  def execute
    twiml = Twilio::TwiML::MessagingResponse.new
    twiml.message(body: "Error")
    twiml.to_s
  end
end
