# frozen_string_literal: true
class ApplicationOperation < ActiveOperation::Base
  def observer(record)
    Observer.for(record)
  end
end
