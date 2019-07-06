# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::PromptOperation, type: :operation do
  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }
    let(:response) { create(:response) }
    let(:phone_call) { response.phone_call }

    it "outputs twiml for digits" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="male">Using the keypad on your touch tone phone, please enter your favourite number.</Say>
        <Gather action="/twilio/phone/favourite_number/prompt_response/#{response.id}.xml" actionOnEmptyResult="false" input="dtmf" numDigits="1" timeout="10"/>
        <Redirect>/twilio/phone/favourite_number/timeout/#{response.id}.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree, response_id: response.id)).to eq(expected)
    end

    it "outputs the prompt_twiml for voice" do
      response.update(prompt_handle: "favourite_number_reason")
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Say voice="male">Now, please state after the tone your reason for picking those numbers as your favourites.</Say>
        <Record action="/twilio/phone/favourite_number/prompt_response/#{ response.id }.xml" maxLength="4" playBeep="true" recordingStatusCallback="/twilio/phone/receive_recording/#{ response.id }" transcribe="true" transcribeCallback="/twilio/phone/transcribe/#{ response.id }"/>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree, response_id: response.id)).to eq(expected)
    end
  end
end
