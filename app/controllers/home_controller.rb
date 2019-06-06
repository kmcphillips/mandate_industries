# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @calls = Call.order(created_at: :desc).page(1)
  end
end
