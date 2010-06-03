# Install hook code here
%{column_mapping.yml gettext_db_extract.yml}.each do |file|
  unless File.exist?(File.join(RAILS_ROOT,'examples/config',file))
    File.copy(File.join(File.dirname(__FILE__),'examples/config',file),File.join(Rails.root,'config'))
  end
end
