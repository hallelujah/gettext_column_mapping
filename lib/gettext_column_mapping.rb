require 'active_support/version'
if Gem::Version.new(ActiveSupport::VERSION::STRING) > Gem::Version.new("2")
  require 'active_support/all'
else
  require 'active_support'
end
require 'active_record'
require 'gettext_column_mapping/mapper'

module GettextColumnMapping
  mattr_accessor :config
  mattr_reader :mapper

  self.config = ActiveSupport::OrderedOptions.new
  self.config.config_file = defined?(Rails) ? File.join(Rails.root,'config','column_mapping.yml') : nil
  self.config.config_parser = :yaml
  self.config.backend = :fast_gettext
  @@mapper = GettextColumnMapping::Mapper.new
end
