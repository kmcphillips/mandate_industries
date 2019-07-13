# frozen_string_literal: true
module Twilio
  module Phone
    class AttachRecordingOperation < ApplicationOperation
      input :recording_id, accepts: Integer, type: :keyword, required: true

      def execute
        recording = Recording.find(recording_id)

        if !recording.audio.attached?
          recording.audio.attach(io: StringIO.new(Faraday.get(recording.url).body), filename: "mandate_recording.wav", content_type: "audio/wav")
          recording.save! && observer(recording).notify
        end
      end
    end
  end
end
