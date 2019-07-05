# frozen_string_literal: true
module Twilio
  class AttachRecordingJob < ApplicationJob
    queue_as :default

    def perform(recording_id:)
      Twilio::Phone::AttachRecordingOperation.call(recording_id: recording_id)
    end
  end
end
