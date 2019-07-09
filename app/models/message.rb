class Message < ApplicationRecord
  belongs_to :sms_conversation

  validates :direction, inclusion: { in: ["sent", "received"] }

  scope :sent, -> { where(direction: "sent") }
  scope :received, -> { where(direction: "received") }
end
