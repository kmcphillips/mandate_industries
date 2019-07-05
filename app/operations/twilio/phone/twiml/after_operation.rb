# frozen_string_literal: true
module Twilio
  module Phone
    module Twiml
      class AfterOperation < Twilio::Phone::BaseOperation
        input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true
        input :after, accepts: Twilio::Phone::Tree::After, type: :keyword, required: true

        def execute
          next_response = phone_call.responses.create!(prompt_handle: after.prompt) unless after.hangup?

          twiml_response = Twilio::TwiML::VoiceResponse.new do |twiml|
            if after.message.present?
              message = after.message
              message = message.call(next_response) if message.is_a?(Proc)
              twiml.say(voice: tree.config[:voice], message: message)
            end

            if after.hangup?
              twiml.hangup
            else
              twiml.redirect("/twilio/phone/#{tree.name}/prompt/#{next_response.id}.xml")
            end
          end

          Rails.logger.info("after_twiml: #{twiml_response.to_s}")
          twiml_response.to_s
        end
      end
    end
  end
end
