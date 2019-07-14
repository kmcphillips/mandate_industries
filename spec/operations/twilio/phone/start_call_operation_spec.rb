# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::StartCallOperation, type: :operation do
  include_examples "twilio phone API call"

  let(:tree) { Twilio::Phone::Tree.new("example_tree") }
  let(:called_number) { "+14445556666" }

  describe "#execute" do
    before do
      allow(TwilioClient).to receive(:send_notification)
      expect(TwilioClient).to receive(:start_call).and_return(call_sid)
    end

    it "creates the PhoneCall" do
      phone_call = described_class.call(to: called_number, tree: tree)
      expect(phone_call).to be_a(PhoneCall)
    end

    it "creates a call record" do
      expect{ described_class.call(to: called_number, tree: tree) }.to change{ PhoneCall.count }.by(1)
      phone_call = PhoneCall.last
      expect(phone_call.sid).to eq(call_sid)
      expect(phone_call.number).to eq(called_number) # This is confusing naming now that it goes backwards too
      expect(phone_call.from_number).to eq(to_number) # Confusing naming
      expect(phone_call.direction).to eq("sent")
    end

    it "sends the SMS notifications" do
      expect(TwilioClient).to receive(:send_notification)
      described_class.call(to: called_number, tree: tree)
    end
  end
end
