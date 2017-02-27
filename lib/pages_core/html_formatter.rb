# encoding: utf-8

module PagesCore
  class HtmlFormatter
    class << self
      def to_html(string, options={})
        self.new(string, options).to_html
      end
    end

    def initialize(string, options={})
      @string = string
      @options = options
    end

    def to_html
      string = parse_images(@string)
      if @options[:shorten] && string.length > @options[:shorten]
        string = string[0..@options[:shorten]] + "..."
      end
      if @options[:append]
        string += " #{@options[:append]}"
      end
      RedCloth.new(string).to_html.html_safe
    end

    private

    def parse_images(string)
      image_expression = /\[image:(\d+)\]/
      string.gsub(image_expression).each do |str|
        id = str.match(image_expression)[1]
        begin
          image = Image.find(id)
          dynamic_image_tag(image, size: '2000x2000', crop: false, upscale: false)
        end
      end
    end
  end
end