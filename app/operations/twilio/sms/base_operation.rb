# frozen_string_literal: true
module Twilio
  module SMS
    class BaseOperation < ApplicationOperation
      input :sms_conversation_id, accepts: Integer, type: :keyword, required: true

      protected

      def conversation
        @conversation ||= SMSConversation.find(sms_conversation_id)
      end
    end
  end
end
