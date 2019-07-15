# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::TimeoutOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: tree.name) }
  let(:response) { create(:response, phone_call: phone_call) }

  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

    it "outputs twiml for digits with a timeout message" do
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

  context "with ToneRatingTree" do
    let(:tree) { Twilio::Phone::Tree.for(:tone_rating) }

    it "outputs twiml without a timeout message" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Redirect>/twilio/phone/tone_rating/prompt/#{response.id + 1}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree, response_id: response.id)).to eq(expected)
      expect(response.reload.timeout).to be(true)
    end
  end
end
