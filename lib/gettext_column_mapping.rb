# coding: utf-8

# Check the version of active_support to requiring all libs
require 'active_support/version'
if Gem::Version.new(ActiveSupport::VERSION::STRING) > Gem::Version.new("2")
  require 'active_support/all'
else
  require 'active_support'
end

# We need active_record
require 'active_record'


require 'gettext_column_mapping/mapper'
require 'gettext_column_mapping/initializer'

module GettextColumnMapping
  mattr_accessor :config
  mattr_reader :mapper
  @@mapper = GettextColumnMapping::Mapper.new
  
  # Configuration default

  self.config = ActiveSupport::OrderedOptions.new
  self.config.config_file = defined?(Rails) ? File.join(Rails.root,'config','column_mapping.yml') : nil
  self.config.config_parser = :yaml
  self.config.backend = :gettext_i18n_rails
  self.config.backend_class = nil
  self.config.model_prefix = "Model"
  self.config.data_prefix = "Data"
end
