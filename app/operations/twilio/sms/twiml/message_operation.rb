# frozen_string_literal: true
module Twilio
  module SMS
    module Twiml
      class MessageOperation < Twilio::SMS::BaseOperation
        input :params, accepts: Hash, type: :keyword, required: true

        def execute
          received_message = conversation.messages.create!(
            direction: "received",
            body: params["Body"],
            sid: params["SmsSid"].presence || params["MessageSid"].presence
          )

          body = Twilio::SMS::Responder.new(received_message).reply

          message = conversation.messages.create!(
            direction: "sent",
            body: body,
          )

          twiml_response = Twilio::TwiML::MessagingResponse.new do |twiml|
            twiml.message(body: body, action: "/twilio/sms/status/#{message.id}")
          end

          Rails.logger.info("message_twiml: #{twiml_response.to_s}")
          twiml_response.to_s
        end
      end
    end
  end
end