# frozen_string_literal: true
class Recording < ApplicationRecord
  belongs_to :phone_call

  has_one :response

  has_one_attached :audio
end
