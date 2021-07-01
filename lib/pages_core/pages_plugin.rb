# frozen_string_literal: true

module PagesCore
  class PagesPlugin < Plugin
    class << self
      def configure_localizations!
        unless @localizations_added
          I18n.load_path += Dir[
            new.root.join("config", "locales", "**", "*.{rb,yml}")
          ]
        end
        @localizations_added = true
      end
    end

    paths["db/migrate"] = "db/migrate"

    admin_menu_item "News",  proc { news_admin_pages_path(@locale) }, :pages,
                    if: proc { Page.news_pages.any? },
                    current: proc { @page && @page.parent.try(&:news_page?) }

    admin_menu_item "Calendar", proc { calendar_admin_pages_path(@locale) }, :pages,
                    if:         proc { Page.with_dates.any? },
                    current:    proc { @page && @page.starts_at? }

    admin_menu_item "Pages", proc { admin_pages_path(@locale) }, :pages

    admin_menu_item "Users", proc { admin_users_path }, :account
  end
end
