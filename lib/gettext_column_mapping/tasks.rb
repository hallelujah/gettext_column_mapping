# coding: utf-8
namespace :test_lib do

  def load_gettext
    require 'gettext'
    require 'gettext/utils'
  end

  def text_domain
    ENV['TEXTDOMAIN'] || "gettext_column_mapping"

  end

  namespace :gettext do

    desc "Redo gettext"
    task :all => [:"test_lib:gettext:find", :"test_lib:gettext:updatepo", :"test_lib:gettext:makemo" ]do
    end

    desc "Find translation in databases"
    task :find do
      $:.unshift File.expand_path('../../../test',__FILE__)
      require 'helper'
      require 'gettext_column_mapping/model_attributes_finder'
      Dir[File.join($gettext_column_mapping_root,'models','**/*.rb')].each do |model|
        require File.join('models',File.basename(model,'.rb'))
      end

      GettextColumnMapping.store_model_attributes :to => File.join($gettext_column_mapping_root,'locale','data.rb')
    end

    desc "Update po"
    task :updatepo do

      load_gettext

      if GetText.respond_to? :update_pofiles_org
        GetText.update_pofiles_org(
          text_domain(),
          Dir.glob("test/{locale,models,static}/**/*.{rb,erb,rjs,rxml}"),
          "version 0.0.1",
          :po_root => 'test/locale',
          :msgmerge=>['--sort-output']
        )
      else #we are on a version < 2.0
        puts "install new GetText with gettext:install to gain more features..."
        #kill ar parser...
        require 'gettext_activerecord/parser'
        module GetText
          module ActiveRecordParser
            module_function
            def init(x);end
          end
        end

        #parse files.. (models are simply parsed as ruby files)
        GetText.update_pofiles(
          text_domain,
          Dir.glob("test/{locale,models,static}/**/*.{rb,erb,haml}"),
          "version 0.0.1",
          'test/locale'
        )
      end


    end

    desc "Create mo-files for L10n"
    task :makemo do
      load_gettext
      GetText.create_mofiles(true,"test/locale","test/locale")
    end

    desc "add a new language"
    task :add_language, [:language] do |_, args|
      language = args.language || ENV["LANGUAGE"]

      # Let's make some pre-verification of the environment.
      if language.nil?
        puts "You need to specify the language to add. Either 'LANGUAGE=eo rake test_lib:gettext:add_languange' or 'rake test_lib:gettext:add_languange[eo]'"
        next
      end
      pot = File.join(locale_path, "#{text_domain}.pot")
      if !File.exists?(pot)
        puts "You don't have a pot file yet, you probably should run 'rake gettext:find' at least once. Tried '#{pot}'."
        next
      end

      # Create the directory for the new language.
      dir = File.join(locale_path, language)
      puts "Creating directory #{dir}"
      FileUtils.mkdir_p(dir)

      # Create the po file for the new language.
      new_po = File.join(locale_path, language, "#{text_domain}.po")
      puts "Initializing #{new_po} from #{pot}."
      system "msginit --locale=#{language} --input=#{pot} --output=#{new_po}"

    end
  end

  def locale_path
    "test/locale"
  end

end
