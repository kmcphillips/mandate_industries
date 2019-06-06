# frozen_string_literal: true
module Twilio
  class PhoneSurveyQuestionResponseOperation < Twilio::BaseOperation
    input :question_handle, accepts: String, type: :keyword, required: true

    def execute
      response_record = call_record.responses.build(question_handle: question_handle, digits: digits)
      response_record.save!

      Rails.logger.tagged(self.class) { |l| l.info("created response #{response_record.inspect}") }

      case question_handle
      when "favourite_number"
        response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(voice: voice, message: "You have selected the number \"#{digits}\" as your favourite. Your response has been recorded. In 5 seconds or less, after the tone please state your reason for picking this number.")
          response.gather(action: "/twilio/phone/survey/favourite_number_reason/response.xml", input: "dtmf", num_digits: 1)
        end
      when "favourite_number_reason"
        response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(voice: voice, message: "Thank you for your input! We have made a note of your reasons. Your opinion is important to us and will be disregarded. Mandate Industries appreciates your business.")
          response.hangup
        end
      else
        raise "Unknown question_handle=#{question_handle}"
      end

      response.to_s
    end

    private

    def digits
      params['Digits'].presence
    end
  end
end
