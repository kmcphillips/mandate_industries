# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioPhoneController, type: :controller do
  include_examples "twilio phone API call"

  let(:phone_call) { phone_call_response.phone_call }
  let(:phone_call_response) { create(:response) } # Eugh, collision on local var :response with controller specs
  let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }
  let(:twiml) { "<Response>expected</Response>" }
  let(:hangup_twiml) {
    <<~EXPECTED
      <?xml version="1.0" encoding="UTF-8"?>
      <Response>
      <Hangup/>
      </Response>
    EXPECTED
  }

  describe "POST#greeting" do
    let(:params) {
      {
        "AccountSid" => account_sid,
        tree_name: :favourite_number,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "creates the session and calls the operation" do
      allow_any_instance_of(Twilio::REST::Api::V2010::AccountContext::MessageList).to receive(:create)
      expect(Twilio::Phone::Twiml::GreetingOperation).to receive(:call).with(phone_call_id: phone_call.id + 1, tree: tree).and_return(twiml)
      post :greeting, format: :xml, params: params
      expect(response.body).to eq(twiml)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::CreateOperation).to_not receive(:call)
      post :greeting, format: :xml, params: params.merge("AccountSid" => "invalid")
      expect(response.body).to eq(hangup_twiml)
    end
  end

  describe "POST#receive_response_recording" do
    it "should be tested"
  end

  describe "POST#transcribe" do
    it "should be tested"
  end

  describe "POST#greeting" do
    it "should be tested"
  end

  describe "POST#prompt" do
    it "should be tested"
  end

  describe "POST#prompt_response" do
    it "should be tested"
  end

  describe "POST#timeout" do
    it "should be tested"
  end
end
