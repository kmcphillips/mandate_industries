# frozen_string_literal: true
module Twilio
  module SMS
    class FindOperation < ApplicationOperation
      input :sms_conversation_id, accepts: Integer, type: :keyword, required: true

      def execute
        SMSConversation.find(sms_conversation_id)
      end
    end
  end
end
