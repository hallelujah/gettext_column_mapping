# coding: utf-8
require 'rails'
require 'gettext_column_mapping'
require 'gettext_column_mapping/initializer'

module GettextColumnMapping
  class Railtie < Rails::Railtie

    config.gettext_column_mapping = GettextColumnMapping.config

    initializer "gettext_column_mapping.after_initialize" do |app|
      GettextColumnMapping::Initializer.run(app.config.gettext_column_mapping)
    end

    rake_tasks do
      load File.expand_path('../tasks.rb',__FILE__)
    end

  end
end

