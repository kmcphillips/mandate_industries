# frozen_string_literal: true
FactoryBot.define do
  factory :response do
    prompt_handle { "favourite_number" }

    phone_call
  end
end
