# frozen_string_literal: true

module PagesCore
  module PageModel
    module DatedPage
      extend ActiveSupport::Concern

      included do
        before_validation :set_all_day_dates
        before_validation :ensure_ends_at

        scope :upcoming, -> { where("ends_at > ?", Time.zone.now) }
        scope :past, -> { where("ends_at <= ?", Time.zone.now) }
        scope :with_dates, -> { where.not(starts_at: nil) }
      end

      module ClassMethods
      end

      # Finds the page's next sibling by date. Returns nil if there
      # isn't one.
      def next_sibling_by_date
        siblings_by_date.where("starts_at >= ?", starts_at)&.first
      end

      # Finds the page's previous sibling by date. Returns nil if
      # there isn't one.
      def previous_sibling_by_date
        siblings_by_date.where("starts_at < ?", starts_at)&.last
      end

      def upcoming?
        return false unless ends_at?

        ends_at > Time.zone.now
      end

      private

      def ensure_ends_at
        return unless starts_at?

        self.ends_at = starts_at if !ends_at? || ends_at < starts_at
      end

      def set_all_day_dates
        return unless all_day?

        self.starts_at = starts_at.beginning_of_day if starts_at?
        self.ends_at = ends_at.end_of_day if ends_at?
      end

      def siblings_by_date
        siblings.reorder("starts_at ASC, pages.id DESC")
                .where
                .not(id: id)
      end
    end
  end
end
