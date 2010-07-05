# coding: utf-8
require 'gettext_activerecord'
module GettextColumnMapping

  class << self
    delegate :locale, :locale=, :to => GetText
  end

  module Backends
    module GettextActiverecord

      def self.included(base)
        base.class_eval do
          class << self

            def human_attribute_name_with_translation(attribute_key_name)
              GetText.s_(gettext_translation_for_attribute_name(attribute_key_name))
            end
            alias_method_chain :human_attribute_name, :translation

          end
        end
      end

    end
  end
end
