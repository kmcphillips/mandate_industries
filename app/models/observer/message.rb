# frozen_string_literal: true
module Observer
  class Message < Base
    def created
      # TODO PhoneCallChannel.broadcast_recent
    end

    def updated
      # TODO PhoneCallChannel.broadcast_recent
    end
  end
end
