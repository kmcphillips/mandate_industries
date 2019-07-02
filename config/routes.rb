Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/receive_recording/:response_id", to: "twilio_phone#receive_response_recording", via: [:get, :post]

  match "twilio/phone/:tree_name/greeting", to: "twilio_phone#greeting", via: [:get, :post]
  match "twilio/phone/:tree_name/prompt/:response_id", to: "twilio_phone#prompt", via: [:get, :post]
  match "twilio/phone/:tree_name/prompt_response/:response_id", to: "twilio_phone#prompt_response", via: [:get, :post]
end
