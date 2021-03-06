# coding: utf-8
module GettextColumnMapping
  class Tasks < Rake::TaskLib

    attr_accessor  :text_domain, :lib_paths, :test_paths, :require_test_libs, :require_libs, :require_files, :options_store, :po_pattern, :mo_args, :locale_path, :options_finder
    attr_reader :version

    def initialize(version, domain = nil, &block)
      @test_paths = []
      @require_libs = []
      @require_test_libs = []
      @require_files = []
      @options_store = {}
      @po_pattern = nil
      @options_finder = {}
      @locale_path = 'locale'
      @version = version
      @text_domain = domain
      yield self if block_given?
      verify_variables
      define
    end

    def verify_variables
     @options_finder = {:to => File.join(locale_path, 'data.rb')}.merge(@options_finder)
     @options_store = {:po_root => locale_path}.merge(@options_store)
     @po_pattern ||= "locale/data.rb"
    end

    def text_domain
      @text_domain ||= ENV['TEXTDOMAIN'] || "gettext_column_mapping"
    end

    def load_gettext
      require 'gettext'
      require 'gettext/utils'
    end

    def po_root
      options_store[:po_root] || locale_path
    end

    private

    def define
      require_libs.each do |lib|
        require lib
      end

      task :environment 
      namespace :gettext_column_mapping do
        desc "Redo gettext"
        task :all => [:"gettext_column_mapping:find", :"gettext_column_mapping:updatepo", :"gettext_column_mapping:makemo" ]do
        end

        desc "Find translation in databases"
        task :find  => [:environment] do
          test_paths.each do |path|
            $:.unshift(path)
          end
          require_test_libs.each do |lib|
            require lib
          end
          require_files.each do |file_path|
            require file_path
          end

          require 'gettext_column_mapping/model_attributes_finder'
          GettextColumnMapping.store_model_attributes(options_finder) 

        end

        desc "Update po"
        task :updatepo do

          load_gettext

          if GetText.respond_to? :update_pofiles_org
            GetText.update_pofiles_org(
              text_domain(),
              Dir.glob(po_pattern),
              version,
              options_store
            )
          else #we are on a version < 2.0
            puts "install new GetText with gettext:install to gain more features..."
            #kill ar parser...
            require 'gettext_activerecord/parser'
            # Need to use this eval hook since we define a module in a method
            Object.eval <<-HOOK
            module GetText
              module ActiveRecordParser
                module_function
                def init(x);end
              end
            end
            HOOK

            #parse files.. (models are simply parsed as ruby files)
            GetText.update_pofiles(
              text_domain,
              Dir.glob(po_pattern),
              version,
              options_store[:po_root]
            )
          end


        end

        desc "Create mo-files for L10n"
        task :makemo do
          load_gettext
          GetText.create_mofiles(options_store[:verbose], po_root, locale_path)
        end

        desc "add a new language"
        task :add_language, [:language] do |_, args|
          language = args.language || ENV["LANGUAGE"]

          # Let's make some pre-verification of the environment.
          if language.nil?
            puts "You need to specify the language to add. Either 'LANGUAGE=eo rake test_lib:gettext:add_languange' or 'rake test_lib:gettext:add_languange[eo]'"
            next
          end
          pot = File.join(po_root, "#{text_domain}.pot")
          if !File.exists?(pot)
            puts "You don't have a pot file yet, you probably should run 'rake gettext:find' at least once. Tried '#{pot}'."
            next
          end

          # Create the directory for the new language.
          dir = File.join(po_root, language)
          puts "Creating directory #{dir}"
          FileUtils.mkdir_p(dir)

          # Create the po file for the new language.
          new_po = File.join(po_root, language, "#{text_domain}.po")
          puts "Initializing #{new_po} from #{pot}."
          system "msginit --locale=#{language} --input=#{pot} --output=#{new_po}"

        end
      end

    end
  end
end
