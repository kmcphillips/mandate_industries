class PhoneCallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "phone_call:recent"
  end

  def unsubscribed
  end

  class << self
    def broadcast_recent
      phone_calls = PhoneCall.received.recent
      html = HomeController.render(partial: "home/phone_calls", locals: { phone_calls: phone_calls })
      PhoneCallChannel.broadcast_to("recent", html)
    end
  end
end
