module GettextColumnMapping
  module Parser

    class << self

      attr_reader :parser

      def init(config)
        @parser = locate_parser(config.config_parser)
      end

      def parse(file)
        results = {}
        h = @parser.parse(file)
        h.each do |k,v|
          results[k.to_s] = HashWithIndifferentAccess.new(v)
        end if h
        results
      end

      def locate_parser(mod)
        case mod
        when Module
          mod
        when Symbol
          require "gettext_column_mapping/parser/#{mod.to_s}"
          GettextColumnMapping::Parser.const_get(mod.to_s.classify)
        else
          require "gettext_column_mapping/parser/yaml"
          GettextColumnMapping::Parser::Yaml
        end
      end

    end

  end
end
