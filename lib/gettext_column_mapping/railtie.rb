# coding: utf-8
require 'rails'
require 'gettext_column_mapping'
require 'gettext_column_mapping/initializer'

module GettextColumnMapping
  class Railtie < Rails::Railtie

    rake_tasks do
      load File.expand_path('../../../tasks/gettext_column_mapping.rake',__FILE__)
    end

  end
end

