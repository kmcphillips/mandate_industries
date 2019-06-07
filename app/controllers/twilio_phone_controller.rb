# frozen_string_literal: true
class TwilioPhoneController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :validate_webhook

  def greeting
    respond_to do |format|
      format.xml do
        phone_call = Twilio::CreatePhoneCallOperation.call(params: params_hash)
        render xml: Twilio::PhonePromptOperation.call(phone_call_id: phone_call.id, incoming_response_id: nil)
      end
    end
  end

  def prompt
    respond_to do |format|
      format.xml do
        phone_call = Twilio::FindPhoneCallOperation.call(params: params_hash)
        Twilio::PhonePromptUpdateResponseOperation.call(phone_call_id: phone_call.id, response_id: params[:response_id].to_i, params: params_hash)
        render xml: Twilio::PhonePromptOperation.call(phone_call_id: phone_call.id, incoming_response_id: params[:response_id].to_i)
      end
    end
  end

  def receive_response_recording
    respond_to do |format|
      format.html do
        phone_call = Twilio::FindPhoneCallOperation.call(params: params_hash)
        Twilio::PhoneReceiveRecordingOperation.call(phone_call_id: phone_call.id, response_id: params[:response_id].to_i, params: params_hash)

        head :ok
      end
    end
  end

  private

  def validate_webhook
    if params["AccountSid"] != Rails.application.credentials.twilio![:account_sid]
      respond_to do |format|
        format.xml do
          render xml: Twilio::PhoneRespondErrorOperation.call()
        end
      end
    end
  end

  def params_hash
    params.permit!.to_h.except("controller", "action", "format", "response_id", "prompt_handle")
  end
end
