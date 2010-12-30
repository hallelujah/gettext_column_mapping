require 'gettext_column_mapping/parent_level/attr_methods'
module GettextColumnMapping

  module ParentLevel

    class << self

      def data_prefix
        GettextColumnMapping.config.data_prefix
      end

      def locate_parser(mod)
        case mod
        when Module
          mod
        when Symbol
          require "gettext_column_mapping/parser/#{mod.to_s}"
          GettextColumnMapping::Parser.const_get(mod.to_s.classify)
        else
          require "gettext_column_mapping/parser/yaml"
          GettextColumnMapping::Parser::Yaml
        end
      end

      def load_config
        @column_attributes_translation = {}
        @attributes_translation = {}
        mod = GettextColumnMapping.config.parent_level_parser
        file = GettextColumnMapping.config.parent_level_file
        @parent_level_config = HashWithIndifferentAccess.new(locate_parser(mod).parse(file))
      end

      def prefix(klass = nil,column = nil,parent = nil,key = nil)
        prefixes = [data_prefix]
        prefixes << "#{klass.to_s_with_gettext}" if klass
        prefixes << parent[key] if parent
        prefixes << klass.column_map_attribute(column.to_s) if column
        prefixes.join("|")
      end

      def prefix_method(object,method,parent_record,parent_key)
        [prefix(object.class,method,parent_record,parent_key), object[method] ].join("|")
      end

      def translate_key_for_column?(klass, column)
        column_attributes_translation(klass.name).include?(column.to_s)
      end

      def each_config(&block)
        @column_attributes_translation.each do |klass_name,columns| 
          yield(*item_config(klass_name))
        end
      end

      def item_config(klass_name)
        columns =  column_attributes_translation(klass_name)
        parent = parent_attributes_translation(klass_name)
        if parent
          parent_key = parent[:key]
          parent_association = parent[:association]
        end
        conditions = conditions_translation(klass_name)
        results = [klass_name,columns,parent_association,parent_key,conditions]
        yield(*results) if block_given?
        results
      end

      def conditions_translation(klass_name)
        attributes_translation(klass_name) && attributes_translation(klass_name)[:conditions]
      end

      def attributes_translation(klass_name)
        @attributes_translation[klass_name] = @parent_level_config[klass_name.underscore]
      end

      def parent_attributes_translation(klass_name)
        attributes_translation(klass_name) && attributes_translation(klass_name)[:parent]
      end

      def column_attributes_translation(klass_name)
        @column_attributes_translation[klass_name] ||= ((attributes_translation(klass_name) && attributes_translation(klass_name)[:columns]) || []).map(&:to_s)
      end

    end
  end
end

::ActiveRecord::Base.extend GettextColumnMapping::ParentLevel::AttrMethods
