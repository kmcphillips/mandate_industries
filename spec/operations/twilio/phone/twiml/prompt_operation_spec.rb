# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Twiml::PromptOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: tree.name) }
  let(:response) { create(:response, phone_call: phone_call) }

  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

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

  context "with ToneRatingTree" do
    let(:tree) { Twilio::Phone::Tree.for(:tone_rating) }

    it "outputs the prompt_twiml for voice" do
      response.update(prompt_handle: "play_first_tone")
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Play>https://www.mediacollege.com/audio/tone/files/440Hz_44100Hz_16bit_05sec.wav</Play>
        <Redirect>/twilio/phone/tone_rating/prompt_response/#{ response.id }.xml</Redirect>
        </Response>
      EXPECTED
      expect(described_class.call(phone_call_id: phone_call.id, tree: tree, response_id: response.id)).to eq(expected)
    end
  end
end
