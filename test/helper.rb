$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
%w{activesupport activerecord}.each do |p|
  dir = File.expand_path("../../../rails/#{p}", __FILE__)
  if Dir.exists?(dir)
    $LOAD_PATH.unshift(File.join(dir,'lib'))
  end
end
require 'rubygems'
require 'active_record'
require 'active_support/all'
require 'test/unit'
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
