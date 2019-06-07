# frozen_string_literal: true
module Twilio
  class PhoneNextPromptHandleOperation < Twilio::BaseOperation
    input :response_id, accepts: Integer, type: :keyword

    def execute
      response = phone_call.responses.find(response_id) if response_id

      if !response_id
        "favourite_number"
      elsif response.prompt_handle == "favourite_number"
        "second_favourite_number"
      elsif response.prompt_handle == "second_favourite_number"
        "favourite_number_reason"
      elsif response.prompt_handle == "favourite_number_reason"
        nil
      else
        raise "unknown next for #{response.inspect}"
      end
    end
  end
end
