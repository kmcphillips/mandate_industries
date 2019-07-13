# frozen_string_literal: true
module Observer
  class Error < StandardError ; end

  class << self
    def for(record)
      klass = Observer::Null

      begin
        klass = "Observer::#{record.class}".constantize
      rescue NameError
        Rails.logger.tagged("Observer") { |l| l.warn("cannot find observer for #{record.class}") }
      end

      klass.new(record)
    end
  end
end
