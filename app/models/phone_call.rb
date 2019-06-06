# frozen_string_literal: true
class PhoneCall < ApplicationRecord
  validates :sid, presence: true

  has_many :responses
  has_many :recordings
end
