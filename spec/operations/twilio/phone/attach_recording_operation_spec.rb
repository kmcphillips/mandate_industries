# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::AttachRecordingOperation, type: :operation do
  include_examples "twilio phone API call"

  let(:phone_call) { create(:phone_call) }
  let(:recording) { create(:recording, phone_call: phone_call) }
  let(:response) { create(:response, phone_call: phone_call, recording: recording) }

  let(:faraday_response) { double(body: "oh, hello") }

  describe "#execute" do
    before do
      response
    end

    it "attaches and calls back" do
      expect(Faraday).to receive(:get).with(recording.url).and_return(faraday_response)
      described_class.call(recording_id: recording.id)
      expect(recording.audio.download).to eq("oh, hello")
    end
  end
end
