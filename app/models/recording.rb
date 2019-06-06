class Recording < ApplicationRecord
  belongs_to :call

  has_one :response
end
