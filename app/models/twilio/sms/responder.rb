# frozen_string_literal: true
module Twilio
  module SMS
    class Responder
      attr_reader :message, :sms_conversation

      def initialize(message)
        @message = message
        @sms_conversation = message.sms_conversation
      end

      def reply
        "Thank you for texting Mandate Industries! Please visit our website: https://mandate.kev.cool"
      end

      def matches?(matcher)
        body = message.body || ""

        case matcher
        when String, Numeric, Symbol
          body.downcase.include?(matcher.to_s.downcase)
        when Regexp
          matcher.match?(body)
        else
          raise Twilio::InvalidTreeError, "unkown matcher #{matcher}"
        end
      end
    end
  end
end
