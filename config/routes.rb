Rails.application.routes.draw do
  root to: "home#index"

  match "twilio/answer", to: "twilio#answer", via: [:get, :post]
end
