Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/greeting", to: "twilio_phone#greeting", via: [:get, :post]
  match "twilio/phone/prompt/:response_id/:prompt_handle", to: "twilio_phone#prompt", via: [:get, :post]
  match "twilio/phone/receive_recording/:response_id", to: "twilio_phone#receive_response_recording", via: [:get, :post]
end
