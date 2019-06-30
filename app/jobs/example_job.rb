class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.application.credentials.notification_numbers.each do |number|
      twilio_client.messages.create(
        from: Rails.application.credentials.twilio![:phone_number],
        body: "Job processing works!",
        to: number,
      )
    end
  end
end
