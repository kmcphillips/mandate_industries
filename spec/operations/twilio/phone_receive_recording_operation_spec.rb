# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhoneReceiveRecordingOperation, type: :operation do
  let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:auth_token) { "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" }
  let(:call_sid) { "CA5073183d7484999999999999747bf790" }
  let(:recording_sid) { "REdddddddddddddddddddddddddddddddd" }
  let(:recording_url) { "https://api.twilio.com/2010-04-01/Accounts/#{account_sid}/Recordings/#{recording_sid}" }
  let(:question_handle) { "favourite_number" }
  let(:params) {
    {
      "AccountSid" => account_sid,
      "CallSid" => call_sid,
      "RecordingSid" => recording_sid,
      "RecordingUrl" => recording_url,
      "RecordingStatus" => "completed",
      "RecordingDuration" => "2",
      "RecordingChannels" => "1",
      "RecordingSource" => "RecordVerb",
      "RecordingStartTime"=>"Thu, 06 Jun 2019 23:17:34 +0000",
      "ErrorCode" => "0",
    }
  }
  let(:phone_call) {
    PhoneCall.create!(
      number: "+12048005721",
      caller_number: "+16135551234",
      caller_city: "OTTAWA",
      caller_province: "ON",
      caller_country: "CA",
      sid: call_sid,
    )
  }
  let(:response) {
    phone_call.responses.create!(
      question_handle: question_handle,
    )
  }

  before do
    phone_call
  end

  describe "#execute" do
    it "handles valid SID and returns" do
      result = described_class.call(params: params)
      expect(result).to_not match(/Hangup/)
    end

    it "creates a recording record" do
      expect{ described_class.call(params: params) }.to change{ phone_call.reload.recordings.size }.by(1)
      recording = phone_call.recordings.last
      expect(recording.url).to eq(recording_url)
    end

    context "with response_id" do
      before do
        response
      end

      it "associates it to the response" do
        result = described_class.call(params: params.merge("response_id" => response.id.to_s))
        expect(result).to_not match(/Hangup/)
        expect(response.reload.recording).to eq(phone_call.recordings.last)
      end
    end

    context "with invalid SID" do
      let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaa99" }

      it "handles valid SID and returns" do
        result = described_class.call(params: params)
        expect(result).to match(/Hangup/)
      end
    end
  end
end
