# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhoneNextPromptHandleOperation, type: :operation do
  include_examples "twilio API call"

  let(:phone_call) { create(:phone_call, number: to_number, caller_number: from_number, sid: call_sid) }
  let(:response) { create(:response, phone_call: phone_call, prompt_handle: prompt_handle) }
  let(:prompt_handle) { "favourite_number" }

  describe "#execute" do
    it "knows the first handle" do
      expect(Twilio::PhoneNextPromptHandleOperation.call(phone_call_id: phone_call.id, response_id: nil)).to eq("favourite_number")
    end

    context "response prompt 'favourite_number'" do
      let(:prompt_handle) { "favourite_number" }

      it "knows the next handle" do
        expect(Twilio::PhoneNextPromptHandleOperation.call(phone_call_id: phone_call.id, response_id: response.id)).to eq("second_favourite_number")
      end
    end

    context "response prompt 'second_favourite_number'" do
      let(:prompt_handle) { "second_favourite_number" }

      it "knows the next handle" do
        expect(Twilio::PhoneNextPromptHandleOperation.call(phone_call_id: phone_call.id, response_id: response.id)).to eq("favourite_number_reason")
      end
    end

    context "response prompt 'favourite_number_reason'" do
      let(:prompt_handle) { "favourite_number_reason" }

      it "knows the next handle" do
        expect(Twilio::PhoneNextPromptHandleOperation.call(phone_call_id: phone_call.id, response_id: response.id)).to be_nil
      end
    end
  end
end
