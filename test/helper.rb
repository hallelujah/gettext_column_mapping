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
require 'active_record/fixtures'
ActiveRecord::Base.logger = Logger.new(logfile)
migrator = ActiveRecord::Migrator.new(:up,File.expand_path('../db/migrate',__FILE__),nil)

if ! migrator.pending_migrations.blank? || ENV['REMIGRATE']
  ActiveRecord::Base.connection.execute("DROP DATABASE gettext_column_mapping")
  ActiveRecord::Base.connection.execute("CREATE DATABASE gettext_column_mapping")
  ActiveRecord::Base.establish_connection(:test)

  class ActiveRecord::Migration
    def self.load_data(filename, dir = File.expand_path('../db/fixtures',__FILE__))
      Fixtures.create_fixtures(dir, filename)
    end
  end

  # Migrate up
  puts "Migrate up"
  ActiveRecord::Migrator.migrate(File.expand_path('../db/migrate',__FILE__),nil)
end
$gettext_column_mapping_root = File.dirname(__FILE__)
FileUtils.mkdir_p(File.join($gettext_column_mapping_root,'locale'))
