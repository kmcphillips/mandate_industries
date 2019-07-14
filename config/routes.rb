Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/phone/receive_recording/:response_id", to: "twilio_phone#receive_response_recording", as: :twilio_phone_receive_recording, via: [:get, :post]
  match "twilio/phone/transcribe/:response_id", to: "twilio_phone#transcribe", as: :twilio_phone_transcribe, via: [:get, :post]
  match "twilio/phone/:tree_name/inbound", to: "twilio_phone#inbound", as: :twilio_phone_inbound, via: [:get, :post]
  match "twilio/phone/:tree_name/outbound", to: "twilio_phone#outbound", as: :twilio_phone_outbound, via: [:get, :post]
  match "twilio/phone/:tree_name/prompt/:response_id", to: "twilio_phone#prompt", as: :twilio_phone_prompt, via: [:get, :post]
  match "twilio/phone/:tree_name/prompt_response/:response_id", to: "twilio_phone#prompt_response", as: :twilio_phone_prompt_response, via: [:get, :post]
  match "twilio/phone/:tree_name/timeout/:response_id", to: "twilio_phone#timeout", as: :twilio_phone_timeout, via: [:get, :post]

  match "twilio/sms/status/:message_id", to: "twilio_sms#status", as: :twilio_sms_status, via: [:get, :post]
  match "twilio/sms/message", to: "twilio_sms#message", as: :twilio_sms_message, via: [:get, :post]
end
