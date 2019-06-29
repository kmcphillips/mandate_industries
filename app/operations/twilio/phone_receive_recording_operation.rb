# frozen_string_literal: true
module Twilio
  class PhoneReceiveRecordingOperation < Twilio::BaseOperation
    input :params, accepts: Hash, type: :keyword, required: true
    input :response_id, accepts: Integer, type: :keyword, required: true

    def execute
      response = phone_call.responses.find(response_id)

      recording = phone_call.recordings.build(
        recording_sid: params["RecordingSid"],
        url: params["RecordingUrl"],
        duration: params["RecordingDuration"].presence,
      )
      recording.save!

      response.recording = recording
      response.save!

      Rails.logger.tagged(self.class) { |l| l.info("created #{recording.inspect}") }

      recording.audio.attach(io: StringIO.new(Faraday.get(recording.url).body), filename: "mandate_recording.wav", content_type: "audio/wav")

      PhoneCallChannel.broadcast_recent

      recording
    end
  end
end
