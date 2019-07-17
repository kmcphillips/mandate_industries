class Message < ApplicationRecord
  include HasDirection

  belongs_to :sms_conversation
end
