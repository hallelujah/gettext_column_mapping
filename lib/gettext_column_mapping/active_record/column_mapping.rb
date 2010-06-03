# TODO: Better API naming

module ActiveRecord
  module ColumnMapping

    class << self
      def included(base)
        base.send :include, ColumnTranslation
        base.class_eval do
          class << self

            # Checks if the class name has to be translated
            def untranslate_all? #_with_untranslatable_columns?
              ! has_translation_class_name?
            end

            # Checks if the column has to be translated
            def untranslate?(columnname)
              ! has_translation_key?(columnname)
            end

            def to_mapping
              @@column_mapping_tables[name.underscore][:class_name] || name.underscore
            rescue
              name.underscore
            end

            # Si on utilise le backend Gettext ActiveRecord de Mutoh
            # Pas propre du tout => il faut faire ça mieux
            unless method_defined?(:human_attribute_name_without_gettext_activerecord)
              # Define it!!!
              def human_attribute_name_without_translation(attr)
                human_attribute_name(attr)
              end
              
              def human_attribute_name_without_gettext_activerecord(attr)
                human_attribute_name_without_translation(attr)
              end
            else
              def human_attribute_name_with_translation(attribute_key_name)
                GetText.s_(gettext_translation_for_attribute_name(attribute_key_name))
              end
              alias_method_chain :human_attribute_name, :translation
            end

            def gettext_translation_for_attribute_name(attribute_key_name)
              if has_translation_key?(attribute_key_name)
                to_s_with_gettext + "|" + self.column_mapping_tables(attribute_key_name.to_s)
              else
                "#{to_s_with_gettext}|#{attribute_key_name.to_s.gsub('_',' ').capitalize}"
              end
            end


            def has_translation_key?(attr_name)
              @@column_mapping_tables.has_key?(self.name.underscore) && ! @@column_mapping_tables[self.name.underscore][:column_names][attr_name].blank?
            rescue
              false
            end

            def has_translation_class_name?()
              column_mapping_tables() && ! column_mapping_tables()[:class_name].blank?
            end

            def column_mapping_tables(key=nil)
              if key
                @@column_mapping_tables[self.name.underscore][:column_names][key]
              else
                @@column_mapping_tables[self.name.underscore]
              end
            end

            unless method_defined?(:to_s_with_gettext)
              def to_s_with_gettext
                to_s
              end
            end

            def to_s_with_gettext_with_translation
              "Model|" +
                if  has_translation_class_name?
                  @@column_mapping_tables[self.name.underscore][:class_name].to_s.split('|').collect(&:humanize).collect{|s| s.split(/\s+/).collect(&:humanize).join(' ')}.join('|')
                else
                  to_s_with_gettext_without_translation
                end
            end
            alias_method_chain :to_s_with_gettext, :translation

            private
            # TODO: Must not depend on Rails
            # TODO: This file must be configurable
            # TODO: If ommited, it must raise an better error
            def init_column_mapping_tables
              @@column_mapping_tables = {}
              translatable_hash = YAML.load(ERB.new(IO.read(File.join(Rails.root,'config','column_mapping.yml'))).result)
              translatable_hash.each do |k,v|
                @@column_mapping_tables[k.to_s] = HashWithIndifferentAccess.new(v)
              end
            end

          end
          init_column_mapping_tables
        end
      end

    end

    module ColumnTranslation
      module ClassMethods
        def self.included(base)
          base.class_eval do
            cattr_accessor :gettext_column_mapping_subclasses
            self.gettext_column_mapping_subclasses = []

            class << self
              def inherited_with_translation(subclass)
                inherited_without_translation(subclass)
                subclass.attr_accessor_with_column_translation(subclass.translation_column_attributes,subclass.translation_parent_attributes)
                self.gettext_column_mapping_subclasses << subclass
              end
              alias_method_chain :inherited, :translation

              # TODO: Must not depend on Rails and allow choosing other prefix than "Data"
              # TODO: The file path must be configurable
              # TODO: If not present, it must fallbacks to an empty Hash
              def load_gettext_db_extract
                @@translation_prefix = "Data"
                @@column_extraction_config = HashWithIndifferentAccess.new(YAML.load(ERB.new(IO.read(File.join(Rails.root,'config','gettext_db_extract.yml'))).result))
              end

              # TODO: improve prefixing
              def prefix(klass = nil,column = nil,parent = nil,key = nil)
                returning(@@translation_prefix.dup + "|") do |str|
                  str << "#{klass.to_s_with_gettext}" if klass
                  str << "|#{parent[key]}" if parent
                    str << "|#{klass.human_attribute_name_without_gettext_activerecord(column.to_s)}" if column
                end
              end

              def has_translation_key_for_column?(column)
                translation_column_attributes && translation_column_attributes[column]
              end

              def translation_attributes
                @translation_attributes ||= @@column_extraction_config[self.name.underscore]
              end

              def translation_parent_attributes
                @translation_parent_attributes ||= translation_attributes && translation_attributes[:parent]
              end

              def translation_column_attributes
                @translation_column_attributes ||= (translation_attributes && translation_attributes[:columns]) || []
              end

              # TODO: improve this function
              # TODO: Better API naming
              def attr_accessor_with_column_translation(method_syms=[],parent=nil)
                if parent
                  parent_klass = parent[:klass]
                  parent_key = parent[:key]
                end
                [method_syms].flatten.each do |method_sym|
                  class_eval(<<-STR,__FILE__,__LINE__)
                    def #{method_sym}_without_translation
                      parent_record = #{parent_klass ? parent_klass : 'nil' }
                      "\#{self.class.prefix(self.class,'#{method_sym}',parent_record,'#{parent_key}')}|\#{self['#{method_sym}']}"
                    end

                    def #{method_sym}
                      s_(#{method_sym}_without_translation)
                    end

                    # It is a bug : we need to load this after rails is loaded !!!
                   # alias_method_chain :#{method_sym}, :column_translation
                      STR
                end
              end
            end
          end
        end
      end

      def self.included(base)
        base.send(:include,ClassMethods)
        base.load_gettext_db_extract
      end

    end
  end
end
