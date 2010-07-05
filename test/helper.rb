# coding: utf-8
require 'extend_lib_path'
require 'rubygems'
require 'gettext_column_mapping'
require 'gettext_column_mapping/initializer'
require 'fileutils'
configuration = {
  'database' => 'gettext_column_mapping',
  'adapter' => 'mysql',
  'host' => 'localhost',
  'username' => 'root',
  'password' => ''
}.with_indifferent_access
require 'gettext_column_mapping'
ActiveRecord::Base.configurations = YAML.load_file(File.expand_path('../config/database.yml',__FILE__))
ActiveRecord::Base.establish_connection(:test)
logfile = File.open(File.expand_path('../log/database.log',__FILE__), 'a')    
logfile.sync = true
ActiveRecord::Base.logger = Logger.new(logfile)
# Migrate down
ActiveRecord::Migrator.migrate('db/migrate',0)
# Migrate up
ActiveRecord::Migrator.migrate('db/migrate',nil)
$gettext_column_mapping_root = File.dirname(__FILE__)
FileUtils.mkdir_p(File.join($gettext_column_mapping_root,'locale'))
