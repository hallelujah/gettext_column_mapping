module GettextColumnMapping
  module Backends
    module Base

      def self.included(base)
        base.class_eval do
          class << self

            def gettext_translation_for_attribute_name(attribute_key_name)
              GettextColumnMapping.mapper.column_translation_for_attribute(self,attribute_key_name.to_s)
            end

            def has_translation_key?(attr_name)
              GettextColumnMapping.mapper.translate_key?(self,attr_name)
            end

            def has_translation_class_name?
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

          end # singleton proxy
        end # class_eval
      end # included definition

    end
  end
end
