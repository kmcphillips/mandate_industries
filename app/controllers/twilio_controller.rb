# frozen_string_literal: true
class TwilioController < ApplicationController
  def answer
    respond_to do |format|
      format.xml { render xml: Twilio::AnswerOperation.call(params: params_hash) }
    end
  end

  private

  def params_hash
    params.permit!.to_h
  end
end
