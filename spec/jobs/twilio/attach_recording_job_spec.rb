require 'rails_helper'

RSpec.describe Twilio::AttachRecordingJob, type: :job do
  let(:recording_id) { 1234 }

  describe "#perform" do
    it "calls the operation" do
      expect(Twilio::Phone::AttachRecordingOperation).to receive(:call).with(recording_id: recording_id)
      Twilio::AttachRecordingJob.perform_now(recording_id: recording_id)
    end
  end
end
