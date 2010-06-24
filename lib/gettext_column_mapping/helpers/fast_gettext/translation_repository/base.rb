module FastGettext
  module TranslationRepository
    class Base

      def plural_with_namespace(seperator=nil,*keys)
        current_translations.plural_with_namespace(seperator,*keys)
      end

    end
  end
end
