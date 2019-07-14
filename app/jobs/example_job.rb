# frozen_string_literal: true
class ExampleJob < ApplicationJob
  queue_as :default

  def perform
    twilio_client ||= Twilio::REST::Client.new(
      Rails.application.credentials.twilio![:account_sid],
      Rails.application.credentials.twilio![:auth_token],
    )

    Rails.application.credentials.notification_numbers.each do |number|
      twilio_client.messages.create(
        from: Rails.application.credentials.twilio![:phone_number],
        body: "Job processing works!",
        to: number,
      )
    end
  end
end
