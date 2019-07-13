# frozen_string_literal: true
module Observer
  class Recording < Base
    def created
      PhoneCallChannel.broadcast_recent
    end

    def updated
      PhoneCallChannel.broadcast_recent
    end
  end
end
