$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'rubygems'
require 'active_record'
configuration = {
  'database' => 'gettext_column_mapping',
  'adapter' => 'mysql',
  'host' => 'localhost',
  'username' => 'root',
  'password' => ''
}.with_indifferent_access
ActiveRecord::Base.configurations['test'] = configuration
ActiveRecord::Base.establish_connection(:test)
logfile = File.open(File.expand_path('../log/database.log',__FILE__), 'a')    
logfile.sync = true
ActiveRecord::Base.logger = Logger.new(logfile)
ActiveRecord::Migrator.migrate('db/migrate',0)
ActiveRecord::Migrator.migrate('db/migrate',nil)
