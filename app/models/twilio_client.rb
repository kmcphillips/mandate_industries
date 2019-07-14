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
      Rails.application.credentials.notification_numbers.map do |to|
        send_message(message: message, to: to)
      end
    end

    def send_message(message:, to:)
      client.messages.create(
        from: Rails.application.credentials.twilio![:phone_number],
        to: to,
        body: message,
      ).sid
    end

    def start_call(tree:, to:)
      client.calls.create(
        from: Rails.application.credentials.twilio![:phone_number],
        to: to,
        url: tree.greeting_url,
      ).sid
    end
  end
end
