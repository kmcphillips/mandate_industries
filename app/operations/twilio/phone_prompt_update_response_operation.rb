# frozen_string_literal: true
module Twilio
  class PhonePromptUpdateResponseOperation < Twilio::BaseOperation
    input :params, accepts: Hash, type: :keyword, required: true
    input :response_id, accepts: Integer, type: :keyword, required: true

    def execute
      response = phone_call.responses.find(response_id)

      if params["Digits"].present?
        response.digits = params["Digits"]
      end

      if params["TranscriptionText"].present? && params["TranscriptionStatus"] == "completed"
        response.transcription = params["TranscriptionText"]
      end

      if response.changed?
        response.save!
        PhoneCallChannel.broadcast_recent
      end
    end
  end
end
