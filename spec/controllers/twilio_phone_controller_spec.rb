# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioPhoneController, type: :controller do
  let(:phone_call) { create(:phone_call) }

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
