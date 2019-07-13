# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer::Base, type: :model do
  subject(:observer) { described_class.new(record) }

  let(:record) { create(:phone_call) }

  describe "#initialize" do
    it "sets the record" do
      expect(observer.record).to eq(record)
    end
  end

  describe "#notify" do
    it "delegates to updated" do
      record.reload
      record.from_city = "changed value"
      record.save!

      expect(observer).to receive(:updated)
      observer.notify
    end

    it "delegates to created" do
      expect(observer).to receive(:created)
      observer.notify
    end

    it "raises on neither" do
      record.reload
      expect { observer.notify }.to raise_error(ArgumentError)
    end
  end
end
