# encoding: utf-8

require 'digest/sha1'
require 'find'
require 'open-uri'
require 'pathname'

# -----

# Framework
require "rails"
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_mailer'

# Assets
require 'jquery/rails/engine'
require 'jquery/ui/rails'
require 'jquery-cookie-rails'
require 'underscore-rails'
require 'jcrop-rails'

require "bcrypt"
require 'vector2d'
require 'RedCloth'
require 'daemon-spawn'
require 'pages_console'
require 'openid'
require 'delayed_job'

require 'dynamic_image'

require 'sass'
require 'json'
require 'coffee-script'

require 'acts_as_list'
require 'acts_as_tree'

require "recaptcha/rails"

require 'thinking-sphinx'
require 'thinking_sphinx/deltas/delayed_delta'


module PagesCore
  class << self

    def load_dependencies!
      load 'acts_as_taggable.rb'
      load 'language.rb'

      load 'pages_core/plugin.rb'

      load 'pages_core/array_extensions.rb'
      load 'pages_core/cache_sweeper.rb'
      load 'pages_core/configuration.rb'
      load 'pages_core/engine.rb'
      load 'pages_core/hash_extensions.rb'
      load 'pages_core/html_formatter.rb'
      load 'pages_core/localizable.rb'
      load 'pages_core/methoded_hash.rb'
      load 'pages_core/pages_plugin.rb'
      load 'pages_core/paginates.rb'
      load 'pages_core/string_extensions.rb'
      load 'pages_core/templates.rb'
      load 'pages_core/version.rb'
    end

    def init!
      load_dependencies!

      # Register with PagesConsole
      #PagesCore.register_with_pages_console
    end

    def version
      VERSION
    end

    def plugin_root
      Pathname.new(File.dirname(__FILE__)).join('..').expand_path
    end

    def application_name
      dir = Rails.root.to_s
      dir.gsub(/\/current\/?$/, '').gsub(/\/releases\/[\d]+\/?$/, '').split('/').last
    end

    def register_with_pages_console
      begin
        require 'pages_console'
        site = PagesConsole::Site.new(self.application_name, Rails.root.to_s)
        PagesConsole.ping(site)
      rescue MissingSourceFile
        # Nothing to do, PagesConsole not installed.
      end
    end

    def configure(options={}, &block)
      if block_given?
        if options[:reset] == :defaults
          load_default_configuration
        elsif options[:reset] === true
          @@configuration = PagesCore::Configuration::SiteConfiguration.new
        end
        yield self.configuration if block_given?
      else
        # Legacy
        options.each do |key,value|
          self.config(key, value)
        end
      end
    end

    def load_default_configuration
      @@configuration = PagesCore::Configuration::SiteConfiguration.new

      config.localizations       :disabled
      config.page_cache          :enabled
      config.text_filter         :textile

      #config.comment_notifications [:author, 'your@email.com']
    end

    def configuration(key=nil, value=nil)
      load_default_configuration unless defined? @@configuration
      if key
        configuration.send(key, value) if value != nil
        configuration.get(key)
      else
        @@configuration
      end
    end
    alias :config :configuration
  end

end

PagesCore.init!