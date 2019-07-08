# frozen_string_literal: true
class SMSConversation < ApplicationRecord
  has_many :messages

  scope :recent, -> { order(created_at: :desc).limit(10) }
end
