# frozen_string_literal: true
module Twilio
  module SMS
    class CreateOperation < ApplicationOperation
      input :tree, accepts: Twilio::SMS::Tree, type: :keyword, required: true
      input :params, accepts: Hash, type: :keyword, required: true

      def execute
        conversation = SMSConversation.new(
          tree_name: tree.name,
          number: params["Called"].presence || params["To"].presence,
          from_number: params["From"].presence,
          from_city: params["FromCity"].presence,
          from_province: params["FromState"].presence,
          from_country: params["FromCountry"].presence,
        )
        conversation.save!

        Rails.logger.tagged(self.class) { |l| l.info("created #{conversation.inspect}") }

        send_notifications

        # PhoneCallChannel.broadcast_recent # TODO

        conversation
      end

      private

      def twilio_client
        @twilio_client ||= Twilio::REST::Client.new(
          Rails.application.credentials.twilio![:account_sid],
          Rails.application.credentials.twilio![:auth_token],
        )
      end

      def send_notifications
        Rails.application.credentials.notification_numbers.each do |number|
          twilio_client.messages.create(
            from: Rails.application.credentials.twilio![:phone_number],
            body: "A new SMS conversation has been started with Mandate Industries. https://mandate.kev.cool/",
            to: number,
          )
        end
      end
    end
  end
end
