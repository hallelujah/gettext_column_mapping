module GettextColumnMapping
  module ParentLevel
    module AttrMethods

      def self.extended(base)
        base.class_eval do 
          class << self
            def inherited_with_column_mapping_parent_level(subclass)
              self.inherited_without_column_mapping_parent_level(subclass)

              parent = GettextColumnMapping::ParentLevel.parent_attributes_translation(subclass)
              attributes = GettextColumnMapping::ParentLevel.column_attributes_translation(subclass)
              subclass.gettext_column_mapping_accessor(attributes,parent)
            end
            alias_method_chain :inherited, :column_mapping_parent_level
          end
        end
      end

      def gettext_column_mapping_accessor(method_syms=[],parent=nil)
        if parent
          parent_klass = parent[:klass]
          parent_key = parent[:key]
        end
        [method_syms].flatten.each do |method_sym|
          class_eval(<<-STR,__FILE__,__LINE__)
                    def #{method_sym}_msgid
                      parent_record = #{parent_klass ? parent_klass : 'nil' }
                      GettextColumnMapping::ParentLevel.prefix_method(self,'#{method_sym}',parent_record,'#{parent_key}')
                    end

                    def #{method_sym}
                      s_(#{method_sym}_msgid)
                    end
                    STR
        end
      end

    end
  end
end
