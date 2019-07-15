# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::GreetingOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: tree.name) }
  let(:response) { create(:response, phone_call: phone_call) }

  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

    it "outputs twiml" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="male">Hello, and thank you for calling Mandate Industries Incorporated!</Say>
        <Redirect>/twilio/phone/favourite_number/prompt/#{response.id + 1}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree)).to eq(expected)
    end
  end

  context "with ToneRatingTree" do
    let(:tree) { Twilio::Phone::Tree.for(:tone_rating) }

    it "outputs twiml" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="female">Hello. Please listen to the following tone:</Say>
        <Redirect>/twilio/phone/tone_rating/prompt/#{response.id + 1}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree)).to eq(expected)
    end
  end
end
