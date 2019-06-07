# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhonePromptUpdateResponseOperation, type: :operation do
  include_examples "twilio API call"

  let(:phone_call) { create(:phone_call, number: to_number, caller_number: from_number, sid: call_sid) }
  let(:response) { create(:response, phone_call: phone_call, prompt_handle: prompt_handle) }
  let(:prompt_handle) { "favourite_number" }
  let(:params) {
    {
      "Called" => to_number,
      "ToState" => "MB",
      "CallerCountry" => "CA",
      "Direction" => "inbound",
      "CallerState" => "ON",
      "ToZip" => "",
      "CallSid" => call_sid,
      "To" => to_number,
      "CallerZip" => "",
      "ToCountry" => "CA",
      "ApiVersion" => "2010-04-01",
      "CalledZip" => "",
      "CalledCity" => "WINNIPEG",
      "CallStatus" => "ringing",
      "From" => from_number,
      "AccountSid" => account_sid,
      "CalledCountry" => "CA",
      "CallerCity" => "OTTAWA",
      "Caller" => from_number,
      "FromCountry" => "CA",
      "ToCity" => "WINNIPEG",
      "FromCity" => "OTTAWA",
      "CalledState" => "MB",
      "FromZip" => "",
      "FromState" => "ON",
      "Digits" => "3",
    }
  }

  describe "#execute" do
    it "updates the digits if present" do
      described_class.call(phone_call_id: phone_call.id, response_id: response.id, params: params)
      expect(response.reload.digits).to eq("3")
    end

    it "does not update the digits if they are not" do
      described_class.call(phone_call_id: phone_call.id, response_id: response.id, params: {})
      expect(response.reload.digits).to be_nil
    end
  end
end
