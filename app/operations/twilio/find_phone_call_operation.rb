# frozen_string_literal: true
module Twilio
  class FindPhoneCallOperation < ApplicationOperation
    input :params, accepts: Hash, type: :keyword, required: true

    def execute
      PhoneCall.find_by!(sid: params["CallSid"])
    end
  end
end
