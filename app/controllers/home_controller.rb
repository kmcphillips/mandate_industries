# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @phone_calls = PhoneCall.inbound.recent
  end
end
