# frozen_string_literal: true
module Twilio
  class PhoneSurveyAnswerOperation < Twilio::BaseOperation
    def execute
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(voice: voice, message: "Thank you for your input! We have recorded your answer #{params['Digits']}. Your opinion is important to us and will be disregarded. Goodbye.")
        response.hangup
      end

      response.to_s
    end
  end
end
