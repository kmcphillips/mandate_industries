# frozen_string_literal: true
module Twilio
  class PhonePromptOperation < Twilio::BaseOperation
    input :greeting, accepts: [true, false], type: :keyword, default: false
    input :prompt_handle, accepts: String, type: :keyword, required: true

    def execute
      response = phone_call.responses.create!(prompt_handle: prompt_handle)

      Rails.logger.tagged(self.class) { |l| l.info("created #{response.inspect}") }

      twiml = Twilio::TwiML::VoiceResponse.new do |twiml|
        twiml.say(voice: voice, message: "Hello, and thank you for calling Mandate Industries Incorporated!") if greeting

        case prompt_handle
        when "favourite_number"
          twiml.say(voice: voice, message: "Please enter your favourite number.")
          twiml.gather(
            action: "/twilio/phone/prompt/#{response.id}/#{prompt_handle}.xml",
            input: "dtmf",
            num_digits: 1
          )
        when "second_favourite_number"
          twiml.say(voice: voice, message: "Thank you. Now in the case that that number is not available, please enter your second favourite number.")
          twiml.gather(
            action: "/twilio/phone/prompt/#{response.id}/#{prompt_handle}.xml",
            input: "dtmf",
            num_digits: 1
          )
        when "favourite_number_reason"
          twiml.say(voice: voice, message: "Your favourite numbers have been recorded. Now, please state after the tone your reason for picking those numbers as your favourites.")
          twiml.record(
            max_length: 5,
            play_beep: true,
            trim: "trim-silence",
            action: "/twilio/phone/prompt/#{response.id}/#{prompt_handle}.xml",
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
  end
end
