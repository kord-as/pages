# encoding: utf-8

module PagesCore
  class Engine < Rails::Engine
    initializer :active_job do |_config|
      if Rails.env.test?
        ActiveJob::Base.queue_adapter = :test
      else
        ActiveJob::Base.queue_adapter = :delayed_job
      end
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Enable asset precompilation
    initializer :assets do |_config|
      Rails.application.config.assets.precompile += %w(
        pages/admin.js
        pages/admin.css
        pages/admin/print.css
        pages/errors.css
        pages/*.gif
        pages/*.png
        pages/*.jpg
      )
    end
  end
end
