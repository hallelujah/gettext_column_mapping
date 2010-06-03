# Install hook code here
unless File.exist?(File.join(RAILS_ROOT,'config','column_mapping.yml'))
  File.copy(File.join(File.dirname(__FILE__),'config','column_mapping.yml'),File.join(Rails.root,'config'))
end
