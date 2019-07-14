# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::CreateOperation, type: :operation do
  include_examples "twilio phone API call"

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
      allow(TwilioClient).to receive(:send_notification)
    end

    let(:tree) { Twilio::Phone::Tree.new("example_tree") }

    it "creates the PhoneCall" do
      phone_call = described_class.call(params: params, tree: tree)
      expect(phone_call).to be_a(PhoneCall)
    end

    it "creates a call record" do
      expect{ described_class.call(params: params.except("direction"), tree: tree) }.to change{ PhoneCall.count }.by(1)
      phone_call = PhoneCall.last
      expect(phone_call.sid).to eq(call_sid)
      expect(phone_call.number).to eq(to_number)
      expect(phone_call.from_number).to eq(from_number)
      expect(phone_call.from_city).to eq("OTTAWA")
      expect(phone_call.from_province).to eq("ON")
      expect(phone_call.from_country).to eq("CA")
      expect(phone_call.direction).to eq("received")
    end

    it "sends the SMS notifications" do
      expect(TwilioClient).to receive(:send_notification)
      described_class.call(params: params, tree: tree)
    end
  end
end
