# frozen_string_literal: true
class TwilioPhoneController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :validate_webhook

  def greeting
    respond_to do |format|
      format.xml do
        phone_call = Twilio::Phone::CreateOperation.call(params: params_hash)
        render xml: Twilio::Phone::Twiml::GreetingOperation.call(phone_call_id: phone_call.id, tree: tree)
      end
    end
  end

  def prompt
    respond_to do |format|
      format.xml do
        phone_call = Twilio::Phone::FindOperation.call(params: params_hash)
        render xml: Twilio::Phone::Twiml::PromptOperation.call(phone_call_id: phone_call.id, tree: tree, response_id: params[:response_id])
      end
    end
  end

  def prompt_response
    respond_to do |format|
      format.xml do
        phone_call = Twilio::Phone::FindOperation.call(params: params_hash)
        render xml: Twilio::Phone::Twiml::PromptResponseOperation.call(phone_call_id: phone_call.id, tree: tree, response_id: params[:response_id].to_i, params_hash: params_hash)
      end
    end
  end

  def transcribe
    respond_to do |format|
      format.xml do
        phone_call = Twilio::Phone::FindOperation.call(params: params_hash)
        Twilio::Phone::UpdateResponseOperation.call(phone_call_id: phone_call.id, response_id: params[:response_id].to_i, params: params_hash)

        head :ok
      end
    end
  end

  def receive_response_recording
    respond_to do |format|
      format.html do
        phone_call = Twilio::Phone::FindOperation.call(params: params_hash)
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
          render xml: Twilio::Twilio::Phone::Twiml::ErrorOperation.call()
        end
      end
    end
  end

  def tree
    @tree ||= Twilio::Phone::Tree.for(params[:tree_name])
  end

  def params_hash
    params.permit!.to_h.except("controller", "action", "format", "response_id", "tree_name")
  end
end
