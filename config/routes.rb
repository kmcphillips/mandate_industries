Rails.application.routes.draw do
  # root to: ""

  match "twilio/answer", to: "twilio#answer", via: [:get, :post]
end
