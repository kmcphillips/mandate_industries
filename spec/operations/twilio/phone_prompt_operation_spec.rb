# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::PhonePromptOperation, type: :operation do
  let(:phone_call) { create(:phone_call, number: to_number, caller_number: from_number, sid: call_sid) }
  # let(:response) { create(:response, phone_call: phone_call, prompt_handle: prompt_handle) }
  let(:prompt_handle) { "favourite_number" }

  describe "#execute" do
    it "returns the prompt with the action" do
      result = described_class.call(phone_call_id: phone_call.id, prompt_handle: prompt_handle)
      expect(result).to_not match(/Hangup/)
      expect(result).to_not match(/Hello/)
      expect(result).to match(/Say/)
    end

    it "returns the prompt with the action and greeting" do
      result = described_class.call(phone_call_id: phone_call.id, prompt_handle: prompt_handle, greeting: true)
      expect(result).to_not match(/Hangup/)
      expect(result).to match(/Hello/)
      expect(result).to match(/Say/)
    end

    context "with 'favourite_number' prompt" do
      it "gathers" do
        result = described_class.call(phone_call_id: phone_call.id, prompt_handle: prompt_handle)
        expect(result).to_not match(/Hangup/)
        expect(result).to match(/Gather/)
        expect(result).to match("/twilio/phone/prompt/#{response.id}/favourite_number.xml")
        expect(phone_call.responses.where(prompt_handle: prompt_handle).count).to eq(1)
      end
    end

    context "with 'second_favourite_number' prompt" do
      it "gathers" do
        result = described_class.call(phone_call_id: phone_call.id, prompt_handle: prompt_handle)
        expect(result).to_not match(/Hangup/)
        expect(result).to match(/Gather/)
        expect(result).to match("/twilio/phone/prompt/#{response.id}/second_favourite_number.xml")
        expect(phone_call.responses.where(prompt_handle: prompt_handle).count).to eq(1)
      end
    end

    context "with 'favourite_number_reason' prompt" do
      let(:prompt_handle) { "favourite_number_reason" }

      it "records" do
        result = described_class.call(phone_call_id: phone_call.id, prompt_handle: prompt_handle)
        expect(result).to_not match(/Hangup/)
        expect(result).to match(/Record/)
        expect(result).to match("/twilio/phone/prompt/#{response.id}/favourite_number_reason.xml")
        expect(phone_call.responses.where(prompt_handle: prompt_handle).count).to eq(1)
      end
    end
  end
end
