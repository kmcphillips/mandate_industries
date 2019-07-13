# frozen_string_literal: true
module Observer
  class Base
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def notify
      if record.destroyed?
        destroyed
      elsif !record.persisted?
        raise Observer::Error, "cannot observe an unsaved record #{record}"
      elsif record.saved_changes.any? && record.saved_changes["id"] && record.saved_changes["id"][0].nil?
        Rails.logger.tagged(self.class) { |l| l.info("#created #{record}") }
        created
      else
        Rails.logger.tagged(self.class) { |l| l.info("#updated #{record} changes=#{record.saved_changes.any?}") }
        updated
      end

      nil
    end

    def created
      Rails.logger.tagged(self.class) { |l| l.warn("#created called with no implementation on #{record}") }
      nil
    end

    def updated
      Rails.logger.tagged(self.class) { |l| l.warn("#updated called with no implementation on #{record}") }
      nil
    end

    def destroyed
      Rails.logger.tagged(self.class) { |l| l.warn("#destroyed called with no implementation on #{record}") }
      nil
    end
  end
end
