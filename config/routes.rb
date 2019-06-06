Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/greeting", to: "twilio_phone#greeting", via: [:get, :post]
  match "twilio/phone/survey_answer", to: "twilio_phone#survey_answer", via: [:get, :post]
end
