# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::SMS::Twiml::MessageOperation, type: :operation do
  include_examples "twilio SMS API call"

  context "with CatFactsTree" do
    let(:tree) { Twilio::SMS::Tree.for(:cat_facts) }
    let(:response) { nil } # TODO
    let(:conversation) { create(:sms_conversation) }
    let(:params) {
      {
        "ToCountry" => "CA",
        "ToState" => "MB",
        "SmsMessageSid" => sms_sid,
        "NumMedia" => "0",
        "ToCity" => "WINNIPEG",
        "FromZip" => "",
        "SmsSid" => sms_sid,
        "FromState" => "ON",
        "SmsStatus" => "received",
        "FromCity" => "OTTAWA",
        "Body" => "Huh",
        "FromCountry" => "CA",
        "To" => to_number,
        "ToZip" => "",
        "NumSegments" => "1",
        "MessageSid" => sms_sid,
        "AccountSid" => account_sid,
        "From" => from_number,
        "ApiVersion" => "2010-04-01",
      }
    }

    it "outputs twiml" do
      expected = <<~EXPECTED
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        TODO
        </Response>
      EXPECTED
      expect(described_class.call(sms_conversation_id: conversation.id, tree: tree, params: params)).to eq(expected)
    end
  end
end
