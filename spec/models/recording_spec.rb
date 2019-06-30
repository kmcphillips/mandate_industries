# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Recording, type: :model do
  let(:recording) { create(:recording) }

  it "is valid" do
    expect(recording).to be_valid
  end
end
