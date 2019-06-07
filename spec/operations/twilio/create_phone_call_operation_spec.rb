# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::CreatePhoneCallOperation, type: :operation do
  include_examples "twilio API call"

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
    }
  }

  describe "#execute" do
    before do
      allow_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList).to receive(:create)
    end

    it "creates the PhoneCall" do
      phone_call = described_class.call(params: params)
      expect(phone_call).to be_a(PhoneCall)
    end

    it "creates a call record" do
      expect{ described_class.call(params: params) }.to change{ PhoneCall.count }.by(1)
      phone_call = PhoneCall.last
      expect(phone_call.sid).to eq(call_sid)
      expect(phone_call.number).to eq(to_number)
      expect(phone_call.caller_number).to eq(from_number)
      expect(phone_call.caller_city).to eq("OTTAWA")
      expect(phone_call.caller_province).to eq("ON")
      expect(phone_call.caller_country).to eq("CA")
    end

    it "sends the SMS notifications" do
      expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList).to receive(:create).with(hash_including(to: '+12222222222'))
      expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList).to receive(:create).with(hash_including(to: '+13333333333'))
      described_class.call(params: params)
    end
  end
end
