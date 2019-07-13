# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer::Recording, type: :model do
  subject(:observer) { described_class.new(record) }

  let(:record) { create(:recording) }

  describe "#created" do
    it "sends notifications" do
      expect(PhoneCallChannel).to receive(:broadcast_recent)
      observer.created
    end
  end

  describe "#updated" do
    it "sends notifications" do
      expect(PhoneCallChannel).to receive(:broadcast_recent)
      observer.updated
    end

    it "handles a new processed attachment  "
  end
end
