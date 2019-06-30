# frozen_string_literal: true
FactoryBot.define do
  factory :phone_call do
    number { "+12048005721" }
    caller_number { "+16135551234" }
    caller_city { "OTTAWA" }
    caller_province { "ON" }
    caller_country { "CA" }
    sid { "CA5073183d7484999999999999747bf790" }
  end
end
