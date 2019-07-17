# frozen_string_literal: true
module HasDirection
  extend ActiveSupport::Concern

  included do
    validates :direction, inclusion: { in: ["outbound", "inbound"] }

    scope :outbound, -> { where(direction: "outbound") }
    scope :inbound, -> { where(direction: "inbound") }
  end
end
