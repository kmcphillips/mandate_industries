require 'rails_helper'

RSpec.describe PhoneCall, type: :model do
  let(:phone_call) { create(:phone_call) }

  it "is valid" do
    expect(phone_call).to be_valid
  end
end
