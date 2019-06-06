Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/greeting", to: "twilio_phone#greeting", via: [:get, :post]
  match "twilio/phone/survey/:question_handle/response", to: "twilio_phone#survey_question_response", via: [:get, :post]
end
