# coding: utf-8
module GettextColumnMapping

  mattr_accessor :activerecord_subclasses
  self.activerecord_subclasses = []

  module Backends
    module Base

      def self.included(base)
        base.class_eval do
          class << self

            def inherited_with_translation(subclass)
              inherited_without_translation(subclass)
#             subclass.attr_accessor_with_column_translation(subclass.translation_column_attributes,subclass.translation_parent_attributes)
              GettextColumnMapping.activerecord_subclasses << subclass
            end
            alias_method_chain :inherited, :translation

            def untranslate_all? #_with_untranslatable_columns?
              ! translate_class_name?
            end

            # Checks if the column has to be translated
            def untranslate?(columnname)
              ! translate_key?(columnname)
            end

            def to_mapping
              Gettext.mapper.class_mapping(self)
            rescue
              name.underscore
            end

            def gettext_translation_for_attribute_name(attribute_key_name)
              GettextColumnMapping.mapper.column_translation_for_attribute(self,attribute_key_name.to_s)
            end

            def translate_key?(attr_name)
              GettextColumnMapping.mapper.translate_key?(self,attr_name)
            end

            def translate_class_name?
              GettextColumnMapping.mapper.translate_class_name?(self)
            end

            def column_map_attribute(key)
              GettextColumnMapping.mapper.map_attribute(self,key)
            end

            unless method_defined?(:to_s_with_gettext)
              def to_s_with_gettext
                to_s
              end
            end

            def to_s_with_gettext_with_translation
              GettextColumnMapping.mapper.to_s_with_gettext(self)
            end
            alias_method_chain :to_s_with_gettext, :translation

            def human_name_without_translation
              to_s_with_gettext
            end

            def human_name
              s_(human_name_without_translation)
            end


          end # singleton proxy
        end # class_eval
      end # included definition

    end
  end
end
