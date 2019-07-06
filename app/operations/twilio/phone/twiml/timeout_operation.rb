# frozen_string_literal: true
module Twilio
  module Phone
    module Twiml
      class TimeoutOperation < Twilio::Phone::BaseOperation
        input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true
        input :response_id, accepts: Integer, type: :keyword, required: true

        def execute
          response = phone_call.responses.find(response_id)
          response.timeout = true
          response.save!

          next_response = phone_call.responses.create!(prompt_handle: response.prompt_handle)

          twiml_response = Twilio::TwiML::VoiceResponse.new do |twiml|
            message = tree.config[:timeout_message]
            if message.present?
              message = message.call(response) if message.is_a?(Proc)
              twiml.say(voice: tree.config[:voice], message: message)
            end

            twiml.redirect("/twilio/phone/#{tree.name}/prompt/#{next_response.id}.xml")
          end

          Rails.logger.info("timeout_twiml: #{twiml_response.to_s}")
          twiml_response.to_s
        end
      end
    end
  end
end
