# encoding: utf-8

module Language

  @@languages = nil
  @@cached_definitions = {}

  # Language definition
  class Definition
    attr_accessor :name, :iso639_3, :iso639_2b, :iso639_2t, :iso639_1, :scope, :type

    def code(type=:iso639_3)
      self.iso639_3
    end

    def to_s
      self.code
    end
  end

  class << self

    # Load language data from the definition file
    def load_data
      languages = Array.new
      File.open(File.join(File.dirname(__FILE__), 'language/iso-fdis-639-3.tab'), "r:utf-8") do |f|
        languages = f.read.split(/[\r]?\n/).map do |line|
          d = Definition.new
          d.iso639_3, d.iso639_2b, d.iso639_2t, d.iso639_1, d.scope, d.type, d.name = line.split(/\t/)
          d
        end
      end
      languages
    end

    def definition(code)
      @@cached_definitions[code] ||= (@@languages ||= Language.load_data).select{|l| l.iso639_3 == code or l.iso639_1 == code}.first
    end

    # Set default language
    def default=(language)
      @@default_language = language
    end

    # Get default language
    def default
      @@default_language
    end

    # Get language name for given code
    def name_for_code(code)
      @@languages ||= Language.load_data
      if definition = @@languages.select{|l| l.iso639_3 == code or l.iso639_1 == code}.first
        return definition.name
      end
    end

    # Get language code for given name
    def code_for_name(name)
      @@languages ||= Language.load_data
      if definition = @@languages.select{|l| l.name == name}.first
        return definition.code
      end
    end

    # Get language names
    def names
      (@@languages ||= Language.load_data).collect{|l| l.name}.sort
    end

    # Get language codes
    def codes
      (@@languages ||= Language.load_data).collect{ |l| l.name}.sort
    end

    # Get language codes and names, ordered alphabetically
    def codes_and_names
      (@@languages ||= Language.load_data).collect{|l| {:code => l.code, :name => l.name}}.sort{|a,b| a[:name] <=> b[:name]}
    end

  end

end

class String
  def to_language_name
    Language.name_for_code(self) || self
  end
  def to_language_code
    Language.code_for_name(self) || self
  end
end
