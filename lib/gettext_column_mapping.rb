# coding: utf-8
# Check the version of active_support to requiring all libs
require 'gettext_column_mapping/version'
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
  self.config.config_file =  nil
  self.config.config_parser = :yaml
  self.config.backend = :gettext_i18n_rails
  self.config.backend_class = nil
  self.config.model_prefix = "Model"
  self.config.data_prefix = "Data"
  self.config.charset = :utf8

  # Additional plugins
  self.config.use_parent_level = false
  self.config.parent_level_file = nil
  self.config.parent_level_parser = :yaml

  def self.charset
    case config.charset.to_s
    when /utf8|utf-8/i
      'UTF-8'
    else
      'UTF-8'
    end
  end
end
