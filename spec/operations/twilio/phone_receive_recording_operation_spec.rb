# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhoneReceiveRecordingOperation, type: :operation do
  let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:auth_token) { "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" }
  let(:call_sid) { "CA5073183d7484999999999999747bf790" }
  let(:recording_sid) { "REdddddddddddddddddddddddddddddddd" }
  let(:question_handle) { "favourite_number" }
  let(:params) {
    {
      "AccountSid" => account_sid,
      "CallSid" => call_sid,
      "RecordingSid" => recording_sid,
      "RecordingUrl" => "https://api.twilio.com/2010-04-01/Accounts/#{account_sid}/Recordings/#{recording_sid}",
      "RecordingStatus" => "completed",
      "RecordingDuration" => "2",
      "RecordingChannels" => "1",
      "RecordingSource" => "RecordVerb",
      "RecordingStartTime"=>"Thu, 06 Jun 2019 23:17:34 +0000",
      "ErrorCode" => "0",
    }
  }
  let!(:call) {
    Call.create!(
      number: "+12048005721",
      caller_number: "+16135551234",
      caller_city: "OTTAWA",
      caller_province: "ON",
      caller_country: "CA",
      sid: call_sid,
    )
  }

  describe "#execute" do
    it "handles valid SID and returns" do
      result = described_class.call(params: params)
      expect(result).to_not match(/Hangup/)
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
