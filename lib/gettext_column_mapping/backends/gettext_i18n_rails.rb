# Weird Hack on ActionController constant error
module ActionController
end
require 'gettext_i18n_rails'
require 'gettext_column_mapping/helpers/fast_gettext'
module GettextColumnMapping
  module Backends
    module GettextI18nRails

      def self.included(base)
        base.class_eval do 
          class << self

            def human_name_without_translation
              to_s_with_gettext
            end

            def human_name
              s_(human_name_without_translation)
            end

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
