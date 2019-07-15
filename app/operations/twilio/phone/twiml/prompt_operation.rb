# frozen_string_literal: true
module Twilio
  module Phone
    module Twiml
      class PromptOperation < Twilio::Phone::BaseOperation
        input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true
        input :response_id, accepts: Integer, type: :keyword, required: true

        def execute
          response = phone_call.responses.find(response_id)
          prompt = tree.prompts[response.prompt_handle]

          twiml_response = Twilio::TwiML::VoiceResponse.new do |twiml|
            if prompt.message.present?
              message = prompt.message
              message = message.call(response) if message.is_a?(Proc)
              twiml.say(voice: tree.config[:voice], message: message)
            elsif prompt.play.present?
              play = prompt.play
              play = play.call(response) if play.is_a?(Proc)
              twiml.play(url: play)
            end

            case prompt.gather&.type
            when :digits
              twiml.gather(
                action: "/twilio/phone/#{tree.name}/prompt_response/#{response.id}.xml",
                input: "dtmf",
                num_digits: prompt.gather.args[:number],
                timeout: prompt.gather.args[:timeout],
                action_on_empty_result: false
              )
              twiml.redirect("/twilio/phone/#{tree.name}/timeout/#{response.id}.xml")
            when :voice
              args = {
                max_length: prompt.gather.args[:length],
                play_beep: prompt.gather.args[:beep],
                # trim: "trim-silence",
                action: "/twilio/phone/#{tree.name}/prompt_response/#{response.id}.xml",
                recording_status_callback: "/twilio/phone/receive_recording/#{response.id}",
              }

              if prompt.gather.args[:transcribe]
                args[:transcribe] = true
                args[:transcribe_callback] = "/twilio/phone/transcribe/#{response.id}"
              end

              twiml.record(args)
            when nil
              twiml.redirect("/twilio/phone/#{tree.name}/prompt_response/#{response.id}.xml")
            else
              raise Twilio::InvalidTreeError, "unknown gather type #{prompt.gather.type.inspect}"
            end
          end

          Rails.logger.info("prompt_twiml: #{twiml_response.to_s}")
          twiml_response.to_s
        end
      end
    end
  end
end
