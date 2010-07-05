require 'helper'

GettextColumnMapping::Initializer.run do |config|
  config.config_file = File.expand_path("../config/column_mapping.yml", __FILE__)
end


FastGettext.add_text_domain 'gettext_column_mapping', :path => File.join($gettext_column_mapping_root,'locale')
FastGettext.default_available_locales = ['en','fr','es'] #all you want to allow
FastGettext.default_text_domain =  'gettext_column_mapping'
