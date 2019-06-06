# frozen_string_literal: true
class TwilioPhoneController < ApplicationController
  skip_before_action :verify_authenticity_token

  def greeting
    respond_to do |format|
      format.xml { render xml: Twilio::PhoneGreetingOperation.call(params: params_hash) }
    end
  end

  def survey_question_response
    respond_to do |format|
      format.xml { render xml: Twilio::PhoneSurveyQuestionResponseOperation.call(question_handle: params[:question_handle], params: params_hash) }
    end
  end

  private

  def params_hash
    params.permit!.to_h.except("controller", "action", "format", "question_handle")
  end
end
