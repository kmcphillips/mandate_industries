# frozen_string_literal: true
module Twilio
  module SMS
    class UpdateMessageOperation < ApplicationOperation
      input :params, accepts: Hash, type: :keyword, required: true
      input :message_id, accepts: Integer, type: :keyword, required: true

      def execute
        message = Message.find(message_id)

        if params["MessageStatus"].present?
          message.status = params["MessageStatus"]
        end

        if message.changed?
          message.save!
          PhoneCallChannel.broadcast_recent # TODO
        end
      end
    end
  end
end
