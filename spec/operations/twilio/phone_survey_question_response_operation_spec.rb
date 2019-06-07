# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhoneSurveyQuestionResponseOperation, type: :operation do
  include_examples "twilio API call"

  let(:phone_call) { create(:phone_call, number: to_number, caller_number: from_number, sid: call_sid) }
  let(:question_handle) { "favourite_number" }
  let(:params) {
    {
      "Called" => "+12048005721",
      "ToState" => "MB",
      "CallerCountry" => "CA",
      "Direction" => "inbound",
      "CallerState" => "ON",
      "ToZip" => "",
      "CallSid" => call_sid,
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
    }
  }

  before do
    phone_call
  end

  describe "#execute" do
    it "handles valid SID and returns" do
      result = described_class.call(question_handle: question_handle, params: params)
      expect(result).to match(/Say/)
    end

    context "with invalid SID" do
      let(:account_sid) { "ACaaaaaaaaaaaaaaaaaaaaaaaaaaaa99" }

      it "handles valid SID and returns" do
        result = described_class.call(question_handle: question_handle, params: params)
        expect(result).to match(/Hangup/)
        expect(result).to_not match(/Say/)
      end
    end
  end
end
