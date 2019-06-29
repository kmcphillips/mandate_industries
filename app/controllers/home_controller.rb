# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @phone_calls = PhoneCall.recent
  end
end
