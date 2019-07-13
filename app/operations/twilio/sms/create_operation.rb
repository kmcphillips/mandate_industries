# frozen_string_literal: true
module Twilio
  module SMS
    class CreateOperation < ApplicationOperation
      input :params, accepts: Hash, type: :keyword, required: true

      def execute
        conversation = SMSConversation.new(
          number: params["Called"].presence || params["To"].presence,
          from_number: params["From"].presence,
          from_city: params["FromCity"].presence,
          from_province: params["FromState"].presence,
          from_country: params["FromCountry"].presence,
        )
        conversation.save! && observer(conversation).notify
        conversation
      end
    end
  end
end
