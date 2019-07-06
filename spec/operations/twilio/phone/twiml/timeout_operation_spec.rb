# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::TimeoutOperation, type: :operation do
  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }
    let(:response) { create(:response) }
    let(:phone_call) { response.phone_call }

    it "outputs twiml for digits" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="male">We did not receive your response in time.</Say>
        <Redirect>/twilio/phone/favourite_number/prompt/#{response.id + 1}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree, response_id: response.id)).to eq(expected)
      expect(response.reload.timeout).to be(true)
    end
  end
end
