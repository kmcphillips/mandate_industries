# frozen_string_literal: true
module Observer
  class Base
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def notify
      if record.saved_changes.any?
        if record.saved_changes["id"] && record.saved_changes["id"][0].nil?
          Rails.logger.tagged(self.class) { |l| l.warn("#created #{record}") }
          created
        else
          Rails.logger.tagged(self.class) { |l| l.warn("#updated #{record}") }
          updated
        end
      else
        raise ArgumentError, "Observer for #{record} was not just saved"
      end

      nil
    end

    def updated
      Rails.logger.tagged(self.class) { |l| l.warn("#updated called with no implementation") }
      nil
    end

    def created
      Rails.logger.tagged(self.class) { |l| l.warn("#created called with no implementation") }
      nil
    end
  end
end
