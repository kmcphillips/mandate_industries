# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer::SMSConversation, type: :model do
  subject(:observer) { described_class.new(record) }

  let(:record) { create(:phone_call) }

  describe "#created" do
    it "sends notifications" do
      # expect(PhoneCallChannel).to receive(:broadcast_recent)
      expect(TwilioClient).to receive(:send_notification)
      observer.created
    end
  end

  describe "#updated" do
    it "sends notifications" do
      # expect(PhoneCallChannel).to receive(:broadcast_recent)
      observer.updated
    end
  end
end
