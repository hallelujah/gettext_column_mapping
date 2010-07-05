# coding: utf-8
# Weird Hack on ActionController constant error
module ActionController
end
require 'gettext_i18n_rails'

module GettextColumnMapping

  class << self
    delegate :locale, :locale=, :to => FastGettext
  end

  module Backends
    module GettextI18nRails

      def self.included(base)
        base.class_eval do 
          class << self

            def human_attribute_name_without_translation(attr)
              human_attribute_name(attr)
            end

            def human_attribute_name_without_gettext_activerecord(attr)
              human_attribute_name_without_translation(attr)
            end

          end
        end
      end

    end
  end
end
