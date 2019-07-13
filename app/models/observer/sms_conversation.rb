# frozen_string_literal: true
module Observer
  class SMSConversation < Base
    def created
      # TODO PhoneCallChannel.broadcast_recent
      TwilioClient.send_notification("A new SMS conversation has been started with Mandate Industries. https://mandate.kev.cool/")
    end

    def updated
      # TODO PhoneCallChannel.broadcast_recent
    end
  end
end
