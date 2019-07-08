Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/receive_recording/:response_id", to: "twilio_phone#receive_response_recording", via: [:get, :post]
  match "twilio/phone/transcribe/:response_id", to: "twilio_phone#transcribe", via: [:get, :post]
  match "twilio/phone/:tree_name/greeting", to: "twilio_phone#greeting", via: [:get, :post]
  match "twilio/phone/:tree_name/prompt/:response_id", to: "twilio_phone#prompt", via: [:get, :post]
  match "twilio/phone/:tree_name/prompt_response/:response_id", to: "twilio_phone#prompt_response", via: [:get, :post]
  match "twilio/phone/:tree_name/timeout/:response_id", to: "twilio_phone#timeout", via: [:get, :post]

  match "twilio/sms/status/:message_id", to: "twilio_sms#status", via: [:get, :post]
  match "twilio/sms/:tree_name/message", to: "twilio_sms#message", via: [:get, :post]
end
