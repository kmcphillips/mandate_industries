class Response < ApplicationRecord
  validates :question_handle, presence: true

  belongs_to :call
  belongs_to :recording, required: false
end
