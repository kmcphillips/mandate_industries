# frozen_string_literal: true
FactoryBot.define do
  factory :recording do
    recording_sid { "REdddddddddddddddddddddddddddddddd" }
    duration { (1..4).to_a.sample.to_s }
    url { "https://api.twilio.com/2010-04-01/Accounts/ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/Recordings/REdddddddddddddddddddddddddddddddd" }

    phone_call
  end
end
