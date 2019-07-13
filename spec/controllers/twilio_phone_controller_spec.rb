# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioPhoneController, type: :controller do
  include_examples "twilio phone API call"

  let(:phone_call) { create(:phone_call, sid: call_sid) }
  let(:phone_call_response) { create(:response, phone_call: phone_call) } # Eugh, collision on local var :response with controller specs
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

    it "creates the call and calls the operation" do
      expect(TwilioClient).to receive(:send_notification)
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

  describe "POST#prompt" do
    let(:params) {
      {
        "AccountSid" => account_sid,
        tree_name: :favourite_number,
        response_id: phone_call_response.id.to_s,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "finds the call and calls the operation" do
      expect(Twilio::Phone::Twiml::PromptOperation).to receive(:call).with(phone_call_id: phone_call.id, tree: tree, response_id: phone_call_response.id).and_return(twiml)
      post :prompt, format: :xml, params: params
      expect(response.body).to eq(twiml)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::Twiml::PromptOperation).to_not receive(:call)
      post :prompt, format: :xml, params: params.merge("AccountSid" => "invalid")
      expect(response.body).to eq(hangup_twiml)
    end
  end

  describe "POST#prompt_response" do
    let(:controller_params) {
      params.merge(
        tree_name: :favourite_number,
        response_id: phone_call_response.id.to_s,
      )
    }
    let(:params) {
      {
        "AccountSid" => account_sid,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "finds the call and calls the operation" do
      expect(Twilio::Phone::Twiml::PromptResponseOperation).to receive(:call).with(
        phone_call_id: phone_call.id,
        tree: tree,
        response_id: phone_call_response.id,
        params: params,
      ).and_return(twiml)
      post :prompt_response, format: :xml, params: controller_params
      expect(response.body).to eq(twiml)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::Twiml::PromptResponseOperation).to_not receive(:call)
      post :prompt_response, format: :xml, params: controller_params.merge("AccountSid" => "invalid")
      expect(response.body).to eq(hangup_twiml)
    end
  end

  describe "POST#timeout" do
    let(:params) {
      {
        "AccountSid" => account_sid,
        tree_name: :favourite_number,
        response_id: phone_call_response.id.to_s,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "finds the call and calls the operation" do
      expect(Twilio::Phone::Twiml::TimeoutOperation).to receive(:call).with(phone_call_id: phone_call.id, tree: tree, response_id: phone_call_response.id).and_return(twiml)
      post :timeout, format: :xml, params: params
      expect(response.body).to eq(twiml)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::Twiml::TimeoutOperation).to_not receive(:call)
      post :timeout, format: :xml, params: params.merge("AccountSid" => "invalid")
      expect(response.body).to eq(hangup_twiml)
    end
  end

  describe "POST#receive_response_recording" do
    let(:controller_params) {
      params.merge(
        response_id: phone_call_response.id.to_s,
      )
    }
    let(:params) {
      {
        "AccountSid" => account_sid,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "finds the call and calls the operation" do
      expect(Twilio::Phone::ReceiveRecordingOperation).to receive(:call).with(phone_call_id: phone_call.id, response_id: phone_call_response.id, params: params)
      post :receive_response_recording, format: :xml, params: controller_params
      expect(response).to have_http_status(:ok)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::ReceiveRecordingOperation).to_not receive(:call)
      post :receive_response_recording, format: :xml, params: controller_params.merge("AccountSid" => "invalid")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST#transcribe" do
    let(:controller_params) {
      params.merge(
        response_id: phone_call_response.id.to_s,
      )
    }
    let(:params) {
      {
        "AccountSid" => account_sid,
        "CallSid" => call_sid,
        "Called" => from_number,
      }
    }

    it "finds the call and calls the operation" do
      expect(Twilio::Phone::UpdateResponseOperation).to receive(:call).with(phone_call_id: phone_call.id, response_id: phone_call_response.id, params: params)
      post :transcribe, format: :xml, params: controller_params
      expect(response).to have_http_status(:ok)
    end

    it "renders error without valid account" do
      expect(Twilio::Phone::UpdateResponseOperation).to_not receive(:call)
      post :transcribe, format: :xml, params: controller_params.merge("AccountSid" => "invalid")
      expect(response).to have_http_status(:ok)
    end
  end
end
