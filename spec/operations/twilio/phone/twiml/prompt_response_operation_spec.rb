# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::PromptResponseOperation, type: :operation do
  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }
    let(:response) { create(:response) }
    let(:phone_call) { response.phone_call }
    let(:params) { { "Digits" => "3" } }

    it "outputs twiml" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="male">Thank you for your selection.</Say>
        <Redirect>/twilio/phone/favourite_number/prompt/#{response.id + 1}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, response_id: response.id, params: params, tree: tree)).to eq(expected)
      expect(response.reload.digits).to eq("3")
    end
  end
end
