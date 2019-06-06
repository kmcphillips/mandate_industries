class Call < ApplicationRecord
  validates :sid, presence: true

  has_many :responses
end
