# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::BaseTree, type: :model do
  let(:described_subclass) do
    Class.new(described_class) do
      class << self
        def tree_name
          "described_subclass"
        end
      end
    end
  end

  describe ".tree" do
    it "is a tree with the name" do
      expect(described_subclass.tree).to be_a(Twilio::Phone::Tree)
      expect(described_subclass.tree.name).to eq("described_subclass")
    end
  end

  describe ".tree_name" do
    it "is the demodulized string" do
      expect(described_class.tree_name).to eq("base")
    end
  end

  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

    it "sets the greeting" do
      expect(tree.greeting).to be_a(Twilio::Phone::Tree::After)
    end

    it "sets the prompts" do
      expect(tree.prompts.keys).to eq(["favourite_number", "second_favourite_number", "favourite_number_reason"])
      expect(tree.prompts.values).to all(be_a(Twilio::Phone::Tree::Prompt))
    end

    context "twiml" do
      let(:response) { create(:response) }
      let(:phone_call) { response.phone_call }
      let(:params_hash) { { "Digits" => "3" } }

      it "outputs greeting_twiml" do
        expected = <<~EXPECTED
          <?xml version="1.0" encoding="UTF-8"?>
          <Response>
          <Say voice="male">Hello, and thank you for calling Mandate Industries Incorporated!</Say>
          <Redirect>/twilio/phone/favourite_number/prompt/#{response.id + 1}.xml</Redirect>
          </Response>
        EXPECTED
        expect(tree.greeting_twiml(phone_call)).to eq(expected)
      end

      it "outputs prompt_twiml" do
        expected = <<~EXPECTED
          <?xml version="1.0" encoding="UTF-8"?>
          <Response>
          <Say voice="male">Using the keypad on your touch tone phone, please enter your favourite number.</Say>
          <Gather action="/twilio/phone/favourite_number/prompt_response/#{response.id}.xml" actionOnEmptyResult="false" input="dtmf" numDigits="1" timeout="10"/>
          </Response>
        EXPECTED
        expect(tree.prompt_twiml(phone_call, response.id.to_s)).to eq(expected)
      end

      it "outputs prompt_response_twiml" do
        expected = <<~EXPECTED
          <?xml version="1.0" encoding="UTF-8"?>
          <Response>
          <Say voice="male">Thank you for your selection.</Say>
          <Redirect>/twilio/phone/favourite_number/prompt/#{response.id + 1}.xml</Redirect>
          </Response>
        EXPECTED
        expect(tree.prompt_response_twiml(phone_call, response.id, params_hash)).to eq(expected)
        expect(response.reload.digits).to eq("3")
      end
    end
  end
end
