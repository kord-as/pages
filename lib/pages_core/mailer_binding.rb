# encoding: utf-8

module PagesCore
  class MailerBinding
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::CaptureHelper
    include ApplicationHelper

    attr_accessor :output_buffer

    def initialize(controller)
      @output_buffer = ""
      @controller = controller
    end

    def set_instance_variables(options={})
      options.each do |key,value|
        self.instance_variable_set("@#{key.to_s}", value)
      end
    end

    def call_template_action(template)
      self.method("template_#{template}").call if self.methods.include? "template_#{template}"
    end

    def cache(key, &block)
      @cache ||= {}
      @cache[key] ||= capture(&block)
      concat(@cache[key], block.binding)
    end

    def get_binding
       binding
    end
  end
end
