# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioClient, type: :model do
  describe ".client" do
    it "returns a client" do
      expect(described_class.client).to be_a(Twilio::REST::Client)
    end
  end

  describe ".send_notification" do
    let(:message) { "Oh, hello" }
    let(:from_number) { Rails.application.credentials.twilio![:phone_number] }
    let(:to_numbers) { [ "+12222222222", "+13333333333" ] }

    it "sends the SMS over the client" do
      to_numbers.each do |to_number|
        expect_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList)
          .to receive(:create)
          .with(from: from_number, body: message, to: to_number)
      end
      described_class.send_notification(message)
    end
  end
end
