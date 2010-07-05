require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gettext_column_mapping"
    gem.summary = %Q{Translate your database columns with gettext}
    gem.description = %Q{Translate your database columns with gettext}
    gem.email = "hery@rails-royce.org"
    gem.homepage = "http://github.com/hallelujah/gettext_column_mapping"
    gem.authors = ["hallelujah"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gettext_column_mapping #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Load my tasks
$:.unshift(File.expand_path('../lib',__FILE__))
require 'gettext_column_mapping/tasks.rb'
GettextColumnMapping::Tasks.new("version 0.0.1") do |t|
  test_root = File.expand_path('../test',__FILE__)
  t.test_paths <<  test_root
  t.require_test_libs = ['fast_gettext_helper','gettext_column_mapping/model_attributes_finder']
  t.require_files = Dir["#{test_root}/models/**/*.rb"].map{|filename| 'models/' + File.basename(filename,'.rb')}
  t.options_store = { :po_root => "#{test_root}/po" , :msgmerge=>['--sort-output'] }
  t.options_finder = {:to => File.join(test_root,'static','data.rb')}
  t.po_pattern = "#{test_root}/{models,static}/**/*.{rb,erb,rjs,rxml}"
  t.locale_path = "#{test_root}/locale"
  t.mo_args = [true,"#{test_root}/po","#{test_root}/locale"]
end
