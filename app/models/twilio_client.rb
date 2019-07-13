# frozen_string_literal: true
module TwilioClient
  class << self
    def client
      @twilio_client ||= Twilio::REST::Client.new(
        Rails.application.credentials.twilio![:account_sid],
        Rails.application.credentials.twilio![:auth_token],
      )
    end

    def send_notification(message)
      Rails.application.credentials.notification_numbers.each do |number|
        client.messages.create(
          from: Rails.application.credentials.twilio![:phone_number],
          body: message,
          to: number,
        )
      end
    end
  end
end
