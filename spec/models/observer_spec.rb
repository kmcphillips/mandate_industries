# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Observer, type: :model do
  describe ".for" do
    let(:phone_call) { create(:phone_call) }

    it "returns an instance of the observer" do
      expect(Observer.for(phone_call)).to be_a(Observer::PhoneCall)
    end

    it "returns a null observer" do
      expect(Observer.for(Object.new)).to be_a(Observer::Null)
    end
  end
end
