module GettextColumnMapping
  module Backends
    module Base

      def self.included(base)
        base.class_eval do
          class << self

            def gettext_translation_for_attribute_name(attribute_key_name)
              if has_translation_key?(attribute_key_name)
                "#{to_s_with_gettext}|#{self.column_mapping_tables(attribute_key_name.to_s)}"
              else
                "#{to_s_with_gettext}|#{attribute_key_name.to_s.gsub('_',' ').capitalize}"
              end
            end

            def has_translation_key?(attr_name)
              GettextColumnMapping.mapper.mappings.has_key?(self.name.underscore) && ! GettextColumnMapping.mapper.mappings[self.name.underscore][:column_names][attr_name].blank?
            rescue
              false
            end

            def has_translation_class_name?()
              column_mapping_tables() && ! column_mapping_tables()[:class_name].blank?
            end

            def column_mapping_tables(key=nil)
              if key
                GettextColumnMapping.mapper.mappings[self.name.underscore][:column_names][key]
              else
                GettextColumnMapping.mapper.mappings[self.name.underscore]
              end
            end

            unless method_defined?(:to_s_with_gettext)
              def to_s_with_gettext
                to_s
              end
            end

            def to_s_with_gettext_with_translation
              "#{GettextColumnMapping.config.model_prefix}|" +
                if  has_translation_class_name?
                  GettextColumnMapping.mapper.mappings[self.name.underscore][:class_name].to_s.split('|').collect(&:humanize).collect{|s| s.split(/\s+/).collect(&:humanize).join(' ')}.join('|')
                else
                  to_s_with_gettext_without_translation
                end
            end
            alias_method_chain :to_s_with_gettext, :translation

          end # singleton proxy
        end # class_eval
      end # included definition

    end
  end
end
