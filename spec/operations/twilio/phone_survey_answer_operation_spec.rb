# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhoneSurveyAnswerOperation, type: :operation do
  let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:auth_token) { "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" }
  let(:params) {
    {
      "Called" => "+12048005721",
      "ToState" => "MB",
      "CallerCountry" => "CA",
      "Direction" => "inbound",
      "CallerState" => "ON",
      "ToZip" => "",
      "CallSid" => "CA5073183d7484999999999999747bf790",
      "To" => "+12048005721",
      "CallerZip" => "",
      "ToCountry" => "CA",
      "ApiVersion" => "2010-04-01",
      "CalledZip" => "",
      "CalledCity" => "WINNIPEG",
      "CallStatus" => "ringing",
      "From" => "+16135551234",
      "AccountSid" => account_sid,
      "CalledCountry" => "CA",
      "CallerCity" => "OTTAWA",
      "Caller" => "+16135551234",
      "FromCountry" => "CA",
      "ToCity" => "WINNIPEG",
      "FromCity" => "OTTAWA",
      "CalledState" => "MB",
      "FromZip" => "",
      "FromState" => "ON",
      "Digits" => "5",
      "controller" => "twilio",
      "action" => "answer",
      "format" => "xml",
    }
  }

  describe "#execute" do
    it "handles valid SID and returns" do
      result = described_class.call(params: params)
      expect(result).to match(/Say/)
    end

    context "with invalid SID" do
      let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaa99" }

      it "handles valid SID and returns" do
        result = described_class.call(params: params)
        expect(result).to match(/Hangup/)
        expect(result).to_not match(/Say/)
      end
    end
  end
end
