module GettextColumnMapping

  class Mapper
    attr_accessor :mappings
    delegate :[], :has_key?, :to => :mappings, :allow_nil => true

    def translate_class_name?(obj)
      ! self[obj.name.underscore][:class_name].blank?
    end

    def map_attribute(obj,key)
      self[obj.name.underscore][:column_names][key]
    end

    def has_translation_key?(obj,key)
      begin
        self.has_key?(obj.name.underscore) && ! self[obj.name.underscore][:column_names][key].blank?
      rescue
        false
      end
    end

    def column_translation_for_attribute(obj,key)
      if has_translation_key?(obj,key)
        "#{obj.to_s_with_gettext}|#{map_attribute(obj,key)}"
      else
        "#{obj.to_s_with_gettext}|#{key.to_s.gsub('_',' ').capitalize}"
      end

    end

  end

end
