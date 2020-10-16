# frozen_string_literal: true

module PagesCore
  class SweepCacheJob < ActiveJob::Base
    queue_as :pages_core

    def perform
      PagesCore::StaticCache.handler.sweep_now!
    end
  end
end
