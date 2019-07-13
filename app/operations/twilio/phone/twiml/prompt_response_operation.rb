# frozen_string_literal: true
module Twilio
  module Phone
    module Twiml
      class PromptResponseOperation < Twilio::Phone::BaseOperation
        input :tree, accepts: Twilio::Phone::Tree, type: :keyword, required: true
        input :response_id, accepts: Integer, type: :keyword, required: true
        input :params, accepts: Hash, type: :keyword, required: true

        def execute
          response = phone_call.responses.find(response_id)
          response = Twilio::Phone::UpdateResponseOperation.call(params: params, response_id: response.id, phone_call_id: phone_call.id)

          prompt = tree.prompts[response.prompt_handle]

          after = prompt.after
          after = Twilio::Phone::Tree::After.new(after.proc.call(response)) if after.proc

          Twilio::Phone::Twiml::AfterOperation.call(phone_call_id: phone_call.id, tree: tree, after: after)
        end
      end
    end
  end
end
