require 'yaml'
require 'gettext_column_mapping/parser'
module GettextColumnMapping

  class Initializer

    class BackendNotLoadedError < LoadError; end
    class ConfigFileNotFoundError < Errno::ENOENT; end

    cattr_accessor :config

    def self.run(config = nil,&block)
      self.config = (config || GettextColumnMapping.config)
      yield(self.config) if block_given?
      Parser.init(self.config) 
      load_config_file
      require_backend
      require_backend_base
      extend_active_record
    end

    private

    class << self

      def require_backend_base
        require 'gettext_column_mapping/backends/base'
      end

      def require_backend

        case config.backend
        when Symbol
          require(lib = "gettext_column_mapping/backends/#{config.backend}")
          config.backend_class = lib.camelize
        when String
          require config.backend
          # config.backend_ext must be set !!
          raise  BackendNotLoadedError, "GettextColumnmapping.config.backend_class must be set if you use your own backend" unless config.bakend_class
        else
          raise BackendNotLoadedError, "You must supply a valid backend :gettext_i18n_rails | :gettext_active_record | 'my_librairie/my_backend', please refer to documentation."
        end

      end

      def extend_active_record
        ActiveRecord::Base.send(:include,GettextColumnMapping::Backends::Base)
        ActiveRecord::Base.send(:include, config.backend_class.constantize)
      end

      def load_config_file
        raise ConfigFileNotFoundError, "#{config.config_file.inspect}. Please set up config.config_file" unless config.config_file && File.exist?(config.config_file)
        GettextColumnMapping.mapper.mappings = Parser.parse(config.config_file)
      end

    end

  end
end
