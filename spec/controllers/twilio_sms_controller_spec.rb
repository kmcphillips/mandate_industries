# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioSMSController, type: :controller do
  include_examples "twilio SMS API call"

  let(:conversation) { message.sms_conversation }
  let(:message) { create(:message, :received) }
  let(:twiml) { "<Response>expected</Response>" }

  describe "POST#message" do
    let(:params) {
      {
        "AccountSid" => account_sid
      }
    }

    it "creates the session and calls the operation" do
      allow_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList).to receive(:create)
      expect(Twilio::SMS::Twiml::MessageOperation).to receive(:call).with(sms_conversation_id: conversation.id + 1, params: params).and_return(twiml)
      post :message, format: :xml, params: params, session: {}
      expect(response.body).to eq(twiml)
    end

    it "loads the session and calls the operation" do
      expect(Twilio::SMS::Twiml::MessageOperation).to receive(:call).with(sms_conversation_id: conversation.id, params: params).and_return(twiml)
      post :message, format: :xml, params: params, session: { sms_conversation_id: conversation.id }
      expect(response.body).to eq(twiml)
    end

    it "renders error without valid account" do
      expected_body = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Message>Error</Message>
        </Response>
      EXPECTED
      expect(Twilio::SMS::Twiml::MessageOperation).to_not receive(:call)
      post :message, format: :xml, params: { "AccountSid" => "invalid" }, session: { sms_conversation_id: conversation.id }
      expect(response.body).to eq(expected_body)
    end
  end

  describe "POST#status" do
    it "should be tested"
  end
end
