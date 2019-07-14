# frozen_string_literal: true
class PhoneCall < ApplicationRecord
  validates :sid, presence: true

  has_many :responses
  has_many :recordings

  validates :direction, inclusion: { in: ["sent", "received"] }

  scope :sent, -> { where(direction: "sent") }
  scope :received, -> { where(direction: "received") }
  scope :recent, -> { order(created_at: :desc).limit(10) }
end
