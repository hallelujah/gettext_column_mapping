$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
%w{rails/activesupport rails/activerecord fast_gettext gettext_i18n_rails gettext_activerecord}.each do |p|
  dir = File.expand_path("../../../#{p}", __FILE__)
  if Dir.exists?(dir)
    $LOAD_PATH.unshift(File.join(dir,'lib'))
  end
end
require 'rubygems'
require 'gettext_column_mapping'
require 'gettext_column_mapping/initializer'
require 'test/unit'
require 'fileuitls'
configuration = {
  'database' => 'gettext_column_mapping',
  'adapter' => 'mysql',
  'host' => 'localhost',
  'username' => 'root',
  'password' => ''
}.with_indifferent_access
require 'gettext_column_mapping'
ActiveRecord::Base.configurations['test'] = configuration
ActiveRecord::Base.establish_connection(:test)
logfile = File.open(File.expand_path('../log/database.log',__FILE__), 'a')    
logfile.sync = true
ActiveRecord::Base.logger = Logger.new(logfile)
# Migrate down
ActiveRecord::Migrator.migrate('db/migrate',0)
# Migrate up
ActiveRecord::Migrator.migrate('db/migrate',nil)
$gettext_column_mapping_root = File.dirname(__FILE__)


GettextColumnMapping::Initializer.run do |config|
  config.config_file = File.expand_path("../config/column_mapping.yml", __FILE__)
end
FileUtils.mkdir_p(File.join($gettext_column_mapping_root,'locale'))
FastGettext.add_text_domain 'gettext_column_mapping', :path => File.join($gettext_column_mapping_root,'locale')
FastGettext.default_available_locales = ['en','fr','es'] #all you want to allow
FastGettext.default_text_domain =  'gettext_column_mapping'
