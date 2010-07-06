# coding: utf-8

module GettextColumnMapping
  #write all found models/columns to a file where GetTexts ruby parser can find them
  def self.store_model_attributes(options)
    file = options[:to] || 'data/model_attributes.rb'
    unless options[:separate_files]
      write_to_unique_file(file,options)
    else
      write_to_separate_files(file,options)
    end
  end

  def self.write_to_unique_file(file,options)
    File.open(file,'w') do |f|
      f.puts "# coding: utf-8"
      f.puts "#DO NOT MODIFY! AUTOMATICALLY GENERATED FILE!"
      ModelAttributesFinder.new.find(options).each do |model,column_names|

        f.puts("s_('#{model.to_s_with_gettext}')") #!Keep in sync with ActiveRecord::Base.human_name

        #all columns namespaced under the model
        column_names.each do |attribute|
          translation = model.gettext_translation_for_attribute_name(attribute)
          f.puts("s_('#{translation}')")
        end
      end
      if GettextColumnMapping.config.use_parent_level
        # Select all classes with parent level
        GettextColumnMapping::ParentLevel.each_config do |klass_name,columns,parent_association,parent_key,conditions|
          model = klass_name.constantize
          options_hash = {}
          if parent_association
           options_hash.merge!(:conditions => conditions, :include => parent_association)
          end
          model.find_each do |record|
            columns.each do |column|
              f.puts("s_('#{record.msgid_for_attribute(column)}')")
            end
          end
        end
      end

      f.puts "#DO NOT MODIFY! AUTOMATICALLY GENERATED FILE!"
    end
  end

  def self.write_to_separate_files(dir,options)
    ModelAttributesFinder.new.find(options).each do |model,column_names|
      file = File.join(dir,model.name.underscore) + ".rb"
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file,'w') do |f|
        f.puts "# coding: utf-8"
        f.puts "#DO NOT MODIFY! AUTOMATICALLY GENERATED FILE!"
        #all columns namespaced under the model
        column_names.each do |attribute|
          translation = model.gettext_translation_for_attribute_name(attribute)
          f.puts("s_('#{translation}')")
        end

        if GettextColumnMapping.config.use_parent_level
          # Select all classes with parent level
          GettextColumnMapping::ParentLevel.item_config(model.name) do |klass_name,columns,parent_association,parent_key,conditions|
            model = klass_name.constantize
            options_hash = {}
            if parent_association
              options_hash.merge!(:conditions => conditions, :include => parent_association)
            end
            model.find_each do |record|
              columns.each do |column|
                f.puts("s_('#{record.msgid_for_attribute(column)}')")
              end
            end
          end
      end

      f.puts "#DO NOT MODIFY! AUTOMATICALLY GENERATED FILE!"

      end
    end
  end

  class ModelAttributesFinder

    def initialize
      return unless Object.const_defined?(:Rails)
      # HOOK ... HOOK wow ... berk
      # Is it safe ?
      $rails_rake_task = false
      # Eager load all classes !! In order to load all ActiveRecord::Base

      # Rails 3.x power
      if Rails::VERSION::MAJOR > 2
        Rails.application.eager_load!
      else
        Rails::Initializer.run(:load_application_classes,Rails.configuration) do |config|
          config.cache_classes = true
        end
      end

    end
    # options:
    #   :ignore_tables => ['cars',/_settings$/,...]
    #   :ignore_columns => ['id',/_id$/,...]
    # current connection ---> {'cars'=>['model_name','type'],...}
    def find(options)
      found = Hash.new([])

      GettextColumnMapping.activerecord_subclasses.each do |subclass|
        next if table_ignored?(subclass,options[:ignore_tables])
        found[subclass] = [] if GettextColumnMapping.config.use_parent_level && ! GettextColumnMapping::ParentLevel.column_attributes_translation(subclass.name).blank?
        subclass.columns.each do |column|
          unless column_ignored?(subclass,column,options[:ignore_columns])
            found[subclass] += [column.name]
          end
        end
      end

      found
    end

    def table_ignored?(subclass, patterns)
      ignored?(subclass.table_name,patterns) || subclass.untranslate_all? || !subclass.table_exists?
    end

    def column_ignored?(subclass,column,patterns)
      ignored?(column.name,patterns) || subclass.untranslate?(column.name)
    end

    def ignored?(name,patterns)
      return false unless patterns
      patterns.detect{|p| (p.is_a?(Regexp) && name=~p) || (p.to_s == name.to_s)}
    end
  end
end
