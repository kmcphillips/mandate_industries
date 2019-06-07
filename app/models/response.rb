# frozen_string_literal: true
class Response < ApplicationRecord
  validates :prompt_handle, presence: true

  belongs_to :phone_call
  belongs_to :recording, required: false
end
