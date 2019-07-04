# frozen_string_literal: true
module Twilio
  module Phone
    class ReceiveRecordingOperation < Twilio::Phone::BaseOperation
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

        recording.audio.attach(io: StringIO.new(Faraday.get(recording.url).body), filename: "mandate_recording.wav", content_type: "audio/wav")

        response.recording = recording
        response.save!

        PhoneCallChannel.broadcast_recent

        recording
      end
    end
  end
end
