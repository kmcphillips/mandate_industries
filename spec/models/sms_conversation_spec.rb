# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SMSConversation, type: :model do
  let(:sms_conversation) { create(:sms_conversation) }

  it "is valid" do
    expect(sms_conversation).to be_valid
  end
end
