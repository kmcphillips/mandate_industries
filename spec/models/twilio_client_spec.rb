# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioClient, type: :model do
  let(:message) { "Oh, hello" }
  let(:from_number) { Rails.application.credentials.twilio![:phone_number] }
  let(:to_number) { "+16666666666" }
  let(:sid) { "SIDaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:response) { double(sid: sid) }

  describe ".client" do
    it "returns a client" do
      expect(described_class.client).to be_a(Twilio::REST::Client)
    end
  end

  describe ".send_notification" do
    let(:to_numbers) { [ "+12222222222", "+13333333333" ] }

    it "sends the SMS over the client and returns the sids" do
      to_numbers.each do |to_number|
        expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList)
          .to receive(:create)
          .with(from: from_number, body: message, to: to_number)
          .and_return(response)
      end
      expect(described_class.send_notification(message)).to eq([sid, sid])
    end
  end

  describe ".send_message" do
    it "sends the SMS over the client and returns the sid" do
      expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList)
        .to receive(:create)
        .with(from: from_number, body: message, to: to_number)
        .and_return(response)
      expect(described_class.send_message(message: message, to: to_number)).to eq(sid)
    end
  end

  describe ".start_call" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

    it "starts a new phone call to the tree" do
      expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::CallList)
        .to receive(:create)
        .with(from: from_number, to: to_number, url: "https://mandate_test.kev.cool/twilio/phone/favourite_number/outbound.xml")
        .and_return(response)
      expect(described_class.start_call(tree: tree, to: to_number)).to eq(sid)
    end
  end
end
