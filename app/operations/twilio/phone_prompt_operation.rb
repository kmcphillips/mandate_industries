# frozen_string_literal: true
module Twilio
  class PhonePromptOperation < Twilio::BaseOperation
    input :incoming_response_id, accepts: Integer, type: :keyword, required: false

    def execute
      response = phone_call.responses.create!(prompt_handle: next_prompt_handle) if next_prompt_handle

      Rails.logger.tagged(self.class) { |l| l.info("created #{response.inspect}") }

      twiml = Twilio::TwiML::VoiceResponse.new do |twiml|
        case next_prompt_handle
        when "favourite_number"
          twiml.say(voice: voice, message: "Hello, and thank you for calling Mandate Industries Incorporated!")
          twiml.say(voice: voice, message: "Using the keypad on your touch tone phone, please enter your favourite number.")
          twiml.gather(
            action: "/twilio/phone/prompt/#{response.id}.xml",
            input: "dtmf",
            num_digits: 1
          )
        when "second_favourite_number"
          twiml.say(voice: voice, message: "Thank you. Now in the case that that number is not available, please enter your second favourite number.")
          twiml.gather(
            action: "/twilio/phone/prompt/#{response.id}.xml",
            input: "dtmf",
            num_digits: 1
          )
        when "favourite_number_reason"
          twiml.say(voice: voice, message: "Your favourite numbers have been recorded. Now, please state after the tone your reason for picking those numbers as your favourites.")
          twiml.record(
            max_length: 3,
            play_beep: true,
            trim: "trim-silence",
            action: "/twilio/phone/prompt/#{response.id}.xml",
            recording_status_callback: "/twilio/phone/receive_recording/#{response.id}",
          )
        when nil
          twiml = Twilio::TwiML::VoiceResponse.new do |response|
            twiml.say(voice: voice, message: "Thank you for your input! We have made a note of your reasons. Your opinion is important to us and will be disregarded. Mandate Industries appreciates your business.")
            twiml.hangup
          end
        else
          raise "invalid prompt_handle=#{prompt_handle}"
        end
      end

      twiml.to_s
    end

    private

    def next_prompt_handle
      return @next_prompt_handle if defined?(@next_prompt_handle)
      @next_prompt_handle ||= Twilio::PhoneNextPromptHandleOperation.call(phone_call_id: phone_call.id, response_id: incoming_response&.id)
    end

    def incoming_response
      return nil unless incoming_response_id.present?
      @incoming_response ||= phone_call.responses.find(incoming_response_id)
    end
  end
end
