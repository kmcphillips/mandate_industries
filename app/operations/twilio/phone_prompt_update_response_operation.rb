# frozen_string_literal: true
module Twilio
  class PhonePromptUpdateResponseOperation < Twilio::BaseOperation
    input :params, accepts: Hash, type: :keyword, required: true
    input :response_id, accepts: Integer, type: :keyword, required: true

    def execute
      response = phone_call.responses.find(response_id)
      # TODO other things
      if digits.present?
        response.digits = digits
        response.save!

        PhoneCallChannel.broadcast_recent
      end
    end

    private

    def digits
      params["Digits"].presence
    end
  end
end
