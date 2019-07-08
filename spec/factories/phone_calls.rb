# frozen_string_literal: true
FactoryBot.define do
  factory :phone_call do
    number { "+12048005721" }
    from_number { "+16135551234" }
    from_city { "OTTAWA" }
    from_province { "ON" }
    from_country { "CA" }
    sid { "CA5073183d7484999999999999747bf790" }
  end
end
