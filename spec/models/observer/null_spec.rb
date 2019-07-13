# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer::Null, type: :model do
  subject(:observer) { described_class.new(record) }

  let(:record) { double }

  describe "#created" do
    it "does nothing" do
      observer.created
    end
  end

  describe "#updated" do
    it "does nothing" do
      observer.updated
    end
  end
end
