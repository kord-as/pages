# frozen_string_literal: true

module Admin
  module PagesHelper
    include PagesCore::Admin::PageBlocksHelper

    def available_templates_for_select
      PagesCore::Templates.names.collect do |template|
        if template == "index"
          ["[Default]", "index"]
        else
          [template.humanize, template]
        end
      end
    end

    def file_embed_code(file)
      "[file:#{file.id}]"
    end

    def news_section_name(page, news_pages)
      if news_pages.select { |p| p.name == page.name }.length > 1
        page_name(page, include_parents: true)
      else
        page_name(page)
      end
    end

    def page_authors(page)
      ([page.author] + User.activated).uniq
    end

    def page_name(page, options = {})
      page_names = if options[:include_parents]
                     page.self_and_ancestors.reverse
                   else
                     [page]
                   end
      safe_join(
        page_names.map { |p| page_name_with_fallback(p) },
        raw(" &raquo; ")
      )
    end

    def publish_time(time)
      if time.year != Time.zone.now.year
        time.strftime("on %b %d %Y at %H:%M")
      elsif time.to_date != Time.zone.now.to_date
        time.strftime("on %b %d at %H:%M")
      else
        time.strftime("at %H:%M")
      end
    end

    private

    def nested_array?(array)
      array.present? && array.first.is_a?(Array)
    end

    def page_name_with_fallback(page)
      if page.name?
        page.name.to_s
      elsif page.localize(I18n.default_locale.to_s).name?
        "(#{page.localize(I18n.default_locale.to_s).name})"
      else
        "(Untitled)"
      end
    end
  end
end
