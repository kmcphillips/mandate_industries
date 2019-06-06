class Response < ApplicationRecord
  validates :question_handle, presence: true

  belongs_to :call
end
