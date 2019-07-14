# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @phone_calls = PhoneCall.received.recent
  end
end
