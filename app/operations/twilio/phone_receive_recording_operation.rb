# frozen_string_literal: true
module Twilio
  class PhoneReceiveRecordingOperation < Twilio::BaseOperation
    def execute
      recording = phone_call.recordings.build(
        recording_sid: params["RecordingSid"],
        url: params["RecordingUrl"],
        duration: params["RecordingDuration"].presence,
      )
      recording.save!

      Rails.logger.tagged(self.class) { |l| l.info("created recording #{recording.inspect}") }

      if params["response_id"].present?
        response_record = phone_call.responses.find(params["response_id"])
        response_record.recording = recording
        response_record.save!
      end

      "OK"
    end
  end
end
