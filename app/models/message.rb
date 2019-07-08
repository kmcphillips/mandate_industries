class Message < ApplicationRecord
  belongs_to :sms_conversation

  validates :body, inclusion: { in: ["sent", "received"] }

  scope :sent, -> { where(direction: "sent") }
  scope :received, -> { where(direction: "received") }
end
