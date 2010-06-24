require 'activesupport'

def load_gettext
  require 'gettext'
  require 'gettext/utils'
  require 'gettext_column_mapping' # Include this library in order to unable column mapping and untranslating
end

@application = "aimfar"
@version = ENV['VERSION'] || "0.0.1"
@application_domain = "Adperf Publisher"

def directory_for_lang(lang)
  File.join('po',lang)
end

task :ensure_environment_defined do
  @po_dir = 'po'
  @lang =  ENV['GLANG']

  if @lang.blank?
    puts "*** The 'GLANG' environment variable must be precised. E.g. rake gettext:create_lang GLANG=es_ES ***"
    exit
  else
    @lang.split('_').first
  end
end

task :create_directory => :ensure_environment_defined do
  dir =directory_for_lang(@lang)
  unless File.exist?(dir)
    puts "### Creating directory #{dir} ###"
    FileUtils.mkdir_p(dir) 
  else
    puts "### Directory #{dir} already exists! Not creating. ###"
  end
end

def out_file(f)
  File.join(@po_dir,@lang,File.basename(f,'.pot') + '.po')
end

namespace :gettext do 

  desc "Update pot/po files."
  task :updatepo => [:environment] do
    load_gettext
    require 'gettext_i18n_rails/haml_parser'


    unless ENV['NO_EXTRACT_DB']
      Rake::Task['gettext:store_model_columns'].invoke
    end
    puts "### Updating po/pot files. ###"
    FileUtils.rm_f("po/#{@application}.pot")

    if GetText.respond_to? :update_pofiles_org
      GetText.update_pofiles_org(@application, Dir.glob("{app,lib,bin,data,static_data}/**/*.{builder,rb,erb,rjs}"), "#{@application_domain} #{@version}", :msgmerge => [:no_wrap,:sort_by_file, :no_fuzzy_matching, :previous],:verbose => true)
    else
      puts "install new GetText with gettext:install to gain more features..."
      #kill ar parser...
      require 'gettext/parser/active_record'
      module GetText
        module ActiveRecordParser
          module_function
          def init(x);end
        end
      end

      GetText.update_pofiles(@application, Dir.glob("{app,lib,bin,data,static_data}/**/*.{builder,rb,erb,rjs}"), "#{@application_domain} #{@version}")#, :msgmerge => [:no_wrap,:sort_by_file, :no_fuzzy_matching, :previous],:verbose => true)
    end
  end

  desc "Create mo-files"
  task :makemo => [:environment] do
    load_gettext
    puts "### Creating mo-files. ###"
    GetText.create_mofiles(true, "po", "locale")
    #    GetText.create_mofiles(true, "po", "locale")
  end

  desc "Create a language file for lang GLANG (fr_FR,en_US etc..)."  
  task :create_lang  => :create_directory do

    #  LANG=es_ES msginit -i ../site.pot -o site.po
    pot_files = Dir.glob(File.join(@po_dir,'*.pot'))
    if pot_files.blank?
      puts 'Unable to find pot files' 
      exit 1
    end
    pot_files.each do |f|
      out_f = out_file(f)
      unless File.exist?(out_f) # Prevent from erasing the old .po
        puts "### Creating #{out_f} ! ###"  
        exec "`msginit -i #{f} -o #{out_f} -l #{@lang} --no-wrap`" 
      else
        puts "### #{out_f} already present! Not created. ###"  
      end
    end

  end

  desc "Extract needed data from DB for gettext"
  task :extract_db do
    puts "Extracting data from databases"
    # don't require this file since it loads all rails framework. 
    # Also use system because exec exits as finished
    system("ruby utils/extract_data_from_db_for_gettext.rb") 

  end

  # This is just an example 
  # Please be inspired!!! :D

  desc "write the data/model_attributes.rb"
  task :store_model_columns  => [:extract_db,:environment] do # => [ :extract_db] do
    require 'gettext_column_mapping/model_attributes_finder'
    FastGettext.silence_errors
    storage_file = 'data/model_attributes.rb'
    puts "writing model translations to: #{storage_file}"
    ignore_tables = [/^sitemap_/, /_versions$/, 'schema_migrations', 'sessions']

    #    GettextColumnMapping::ModelAttributesFinder.new
    #    puts ActiveRecord::Base.send(:subclasses).size
    GettextColumnMapping.store_model_attributes(
      :to => storage_file,
      :ignore_columns => ['id', 'type', 'created_at', 'updated_at'],
      :ignore_tables => ignore_tables
    )

  end
end
