# frozen_string_literal: true
module Twilio
  class BaseOperation < ApplicationOperation
    input :phone_call_id, accepts: Integer, type: :keyword, required: true

    protected

    def voice
      "male"
    end

    def phone_call
      @phone_call ||= PhoneCall.find(phone_call_id)
    end
  end
end
