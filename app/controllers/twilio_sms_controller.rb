# frozen_string_literal: true
class TwilioSMSController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :validate_webhook

  def message
    respond_to do |format|
      format.xml do
        if session[:sms_conversation_id].present?
          conversation = Twilio::SMS::FindOperation.call(sms_conversation_id: session[:sms_conversation_id])
        else
          conversation = Twilio::SMS::CreateOperation.call(params: params_hash)
          session[:sms_conversation_id] = conversation.id
        end

        render xml: Twilio::SMS::Twiml::MessageOperation.call(sms_conversation_id: conversation.id, params: params_hash)
      end
    end
  end

  def status
    respond_to do |format|
      format.xml do
        Twilio::SMS::UpdateMessageOperation.call(message_id: params[:message_id].to_i, params: params_hash)

        head :ok
      end
    end
  end

  private

  def validate_webhook
    if params["AccountSid"] != Rails.application.credentials.twilio![:account_sid]
      respond_to do |format|
        format.xml do
          render xml: Twilio::SMS::Twiml::ErrorOperation.call()
        end
      end
    end
  end

  def params_hash
    params.permit!.to_h.except("controller", "action", "format", "response_id", "tree_name")
  end
end
