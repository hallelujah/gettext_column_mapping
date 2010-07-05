# coding: utf-8
module GettextColumnMapping

  class Mapper
    attr_accessor :mappings
    delegate :[], :has_key?, :to => :mappings, :allow_nil => true


    def class_mapping(obj)
      self[obj.name.underscore][:class_name] || obj.name.underscore
    end

    def translate_class_name?(obj)
      ! self[obj.name.underscore][:class_name].blank?
    end

    def map_attribute(obj,key)
      self[obj.name.underscore][:column_names][key]
    end

    def translate_key?(obj,key)
      begin
        self.has_key?(obj.name.underscore) && ! self[obj.name.underscore][:column_names][key].blank?
      rescue
        false
      end
    end

    def column_translation_for_attribute(obj,key)
      if translate_key?(obj,key)
        "#{obj.to_s_with_gettext}|#{map_attribute(obj,key)}"
      else
        "#{obj.to_s_with_gettext}|#{key.to_s.humanize}"
      end
    end

    def to_s_with_gettext(obj)
      array = [GettextColumnMapping.config.model_prefix]
      if  translate_class_name?(obj)
        array += self[obj.name.underscore][:class_name].to_s.split('|').collect(&:humanize).collect{|s| s.split(/\s+/).collect(&:humanize).join(' ')}
      else
        array += [obj.to_s_with_gettext_without_translation]
      end
      array.join('|')
    end

  end

end
