# frozen_string_literal: true
class TwilioController < ApplicationController
  def answer
    respond_to do |format|
      format.xml do
        render xml: "<TODO></TODO>"
      end
    end
  end
end
