# frozen_string_literal: true
module Twilio
  class PhoneSurveyQuestionResponseOperation < Twilio::BaseOperation
    input :question_handle, accepts: String, type: :keyword, required: true

    def execute
      response_record = call_record.responses.build(question_handle: question_handle, digits: digits)
      response_record.save!

      Rails.logger.tagged(self.class) { |l| l.info("created response #{response_record.inspect}") }

      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(voice: voice, message: "Thank you for your input! We have recorded your answer #{digits}. Your opinion is important to us and will be disregarded. Goodbye.")
        response.hangup
      end

      response.to_s
    end

    private

    def digits
      params['Digits'].presence
    end
  end
end
