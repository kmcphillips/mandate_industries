# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhonePromptOperation, type: :operation do
  include_examples "twilio API call"

  let(:phone_call) { create(:phone_call, number: to_number, caller_number: from_number, sid: call_sid) }
  let(:incoming_response) { create(:response, phone_call: phone_call, prompt_handle: "does_not_exist") }

  describe "#execute" do
    it "returns the prompt for 'favourite_number'" do
      expect(Twilio::PhoneNextPromptHandleOperation).to receive(:call)
        .with(phone_call_id: phone_call.id, response_id: nil)
        .and_return("favourite_number")
      result = described_class.call(phone_call_id: phone_call.id, incoming_response_id: nil)
      expect(result).to_not match(/Hangup/)
      expect(result).to match(/Hello/)
      expect(result).to match(/Gather/)
      expect(phone_call.reload.responses.last.prompt_handle).to eq("favourite_number")
    end

    it "returns the prompt for 'second_favourite_number'" do
      expect(Twilio::PhoneNextPromptHandleOperation).to receive(:call)
        .with(phone_call_id: phone_call.id, response_id: incoming_response.id)
        .and_return("second_favourite_number")
      result = described_class.call(phone_call_id: phone_call.id, incoming_response_id: incoming_response.id)
      expect(result).to_not match(/Hangup/)
      expect(result).to match(/second/)
      expect(result).to match(/Gather/)
      expect(phone_call.reload.responses.last.prompt_handle).to eq("second_favourite_number")
    end

    it "returns the prompt for 'favourite_number_reason'" do
      expect(Twilio::PhoneNextPromptHandleOperation).to receive(:call)
        .with(phone_call_id: phone_call.id, response_id: incoming_response.id)
        .and_return("favourite_number_reason")
      result = described_class.call(phone_call_id: phone_call.id, incoming_response_id: incoming_response.id)
      expect(result).to_not match(/Hangup/)
      expect(result).to match(/tone/)
      expect(result).to match(/Record/)
      expect(phone_call.reload.responses.last.prompt_handle).to eq("favourite_number_reason")
    end

    it "returns the prompt to end call" do
      expect(Twilio::PhoneNextPromptHandleOperation).to receive(:call)
        .with(phone_call_id: phone_call.id, response_id: incoming_response.id)
        .and_return(nil)
      result = described_class.call(phone_call_id: phone_call.id, incoming_response_id: incoming_response.id)
      expect(result).to match(/Hangup/)
      expect(result).to match(/Say/)
    end
  end
end
