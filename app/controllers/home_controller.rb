# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @phone_calls = PhoneCall.order(created_at: :desc).page(1)
  end
end
