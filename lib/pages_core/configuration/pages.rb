# encoding: utf-8

module PagesCore
  module Configuration
    class Pages < Base
      setting :site_name,             :string, "Pages Site"
      setting :default_sender,        :string
      setting :localizations,         :boolean, false
      setting :locales,               :hash
      setting :text_filter,           :symbol, :textile
      setting :page_cache,            :boolean, true
      setting :domain_based_cache,    :boolean, false
      setting :rss_fulltext,          :boolean, true
      setting :image_fallback_url,    :string
      setting :default_author,        :string
      setting :comment_notifications, :array, []
      setting :close_comments_after,  :integer
      setting :comment_honeypot,      :boolean, false
      setting :recaptcha,             :boolean, false
      setting :error_404_layout,      :string
      setting :file_embedder,         :object, PagesCore::FileEmbedder
    end
  end
end
