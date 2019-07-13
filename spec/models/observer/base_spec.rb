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
    it "delegates to #created" do
      expect(observer).to receive(:created)
      observer.notify
    end

    it "delegates to #updated" do
      record.reload
      record.from_city = "changed value"
      record.save!

      expect(observer).to receive(:updated)
      observer.notify
    end

    it "delegates to #updated on no changes" do
      record.reload
      expect(observer).to receive(:updated)
      observer.notify
    end

    it "delegates to #destroyed on destroyed instance" do
      record.destroy
      expect(observer).to receive(:destroyed)
      observer.notify
    end

    context "with unsaved" do
      let(:record) { build(:phone_call) }

      it "raises" do
        expect { observer.notify }.to raise_error(Observer::Error)
      end
    end
  end
end
