# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::SMS::Responder, type: :model do
  include_examples "twilio SMS API call"

  let(:conversation) { message.sms_conversation }
  let(:message) { create(:message, :inbound) }
  subject(:responder) { described_class.new(message) }

  describe "#initialize" do
    it "sets message and conversation" do
      expect(responder.message).to eq(message)
      expect(responder.sms_conversation).to eq(conversation)
    end
  end

  describe "#reply" do
    it "is tested"
  end

  describe "#matches?" do
    let(:message) { create(:message, :inbound, body: "oh, hello") }

    context "String" do
      it "matches ignoring case" do
        expect(responder.matches?("OH, HELLO")).to be(true)
      end

      it "matches a substring" do
        expect(responder.matches?("hello")).to be(true)
      end

      it "does not match" do
        expect(responder.matches?("hi")).to be(false)
      end
    end

    context "Regexp" do
      it "matches the regexp" do
        expect(responder.matches?(/hel.o/)).to be(true)
      end

      it "does not match" do
        expect(responder.matches?(/hi/)).to be(false)
      end
    end

    context "coersed type" do
      let(:message) { create(:message, :inbound, body: "test_123")}

      it "matches a symbol" do
        expect(responder.matches?(:test)).to be(true)
      end

      it "matches an int" do
        expect(responder.matches?(123)).to be(true)
      end
    end

    it "raises with somethign else" do
      expect { responder.matches?(Object.new) }.to raise_error(Twilio::InvalidTreeError)
    end
  end
end
