# frozen_string_literal: true
class TwilioPhoneController < ApplicationController
  skip_before_action :verify_authenticity_token

  def greeting
    respond_to do |format|
      format.xml { render xml: Twilio::PhoneGreetingOperation.call(params: params_hash) }
    end
  end

  def survey_answer
    respond_to do |format|
      format.xml { render xml: Twilio::PhoneSurveyAnswerOperation.call(params: params_hash) }
    end
  end

  private

  def params_hash
    params.permit!.to_h
  end
end
