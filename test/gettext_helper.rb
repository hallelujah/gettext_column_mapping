require 'helper'
GettextColumnMapping::Initializer.run do |config|
  config.backend = :gettext_activerecord
  config.config_file = File.expand_path("../config/column_mapping.yml", __FILE__)
end

GetText.bindtextdomain_to(ActiveRecord, 'gettext_column_mapping', :path => File.join($gettext_column_mapping_root,'locale'))
