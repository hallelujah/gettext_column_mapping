require 'yaml'
require 'gettext_column_mapping/parser'
module GettextColumnMapping

  class Initializer

    class BackendNotLoadedError < LoadError; end

    cattr_accessor :config

    def self.run(config = nil)
      self.config = config || GettextColumnMapping.config
      load_config_file
      load_extract_file
      require_backend
      require_base
    end

    private

    class << self

      def require_backend
        case config.backend
        when Symbol
          require "gettext_column_mapping/backends/#{config.backend}"
        when String
          require config.backend
        else
          raise BackendNotLoadedError, "You must supply a valid backend :fast_gettext | gettext_rails | 'my_librairie/my_backend', please refer to documentation."
        end
      end

      def require_base
        require 'gettext_column_mapping/base'
      end

      def load_config_file
        GettextColumnMapping.mapper.mappings = Parser::Mapping.parse(file,config)
        #file = config.mapping_file
        #raise ConfigFileUnFoundError, "You must supply a valid path" unless File.exist?(file)
      end

    end

  end
end
