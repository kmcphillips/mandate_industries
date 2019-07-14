# frozen_string_literal: true
module Observer
  class PhoneCall < Base
    def created
      if record.direction == "received"
        PhoneCallChannel.broadcast_recent
        TwilioClient.send_notification("A new call has come into Mandate Industries. https://mandate.kev.cool/")
      end
    end

    def updated
      PhoneCallChannel.broadcast_recent
    end
  end
end
