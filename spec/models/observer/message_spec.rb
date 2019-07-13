# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer::Message, type: :model do
  subject(:observer) { described_class.new(record) }

  let(:record) { create(:message) }

  describe "#created" do
    it "sends notifications" do
      # TODO
      observer.created
    end
  end

  describe "#updated" do
    it "sends notifications" do
      # TODO
      observer.updated
    end
  end
end
