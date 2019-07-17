# frozen_string_literal: true
module Twilio
  module SMS
    module Twiml
      class MessageOperation < Twilio::SMS::BaseOperation
        input :params, accepts: Hash, type: :keyword, required: true

        def execute
          inbound_message = conversation.messages.build(
            direction: "inbound",
            body: params["Body"],
            sid: params["SmsSid"].presence || params["MessageSid"].presence
          )

          inbound_message.save! && observer(inbound_message).notify

          body = Twilio::SMS::Responder.new(inbound_message).reply

          message = conversation.messages.build(
            direction: "outbound",
            body: body,
          )

          message.save! && observer(message).notify

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
