module FastGettext
  module Translation

    #translate pluralized
    # some languages have up to 4 plural forms...
    # ns_(singular, plural, plural form 2, ..., count,:seperator => '|')
    # ns_('toto|apple','toto|apples',3)
    def ns_(*keys)
      seperator = keys.pop if keys.last.is_a?(Hash)
      seperator = seperator[:seperator] if seperator
      count = keys.pop
      translations = FastGettext.cached_plural_find_with_name_space seperator, *keys
      selected = FastGettext.pluralisation_rule.call(count)
      selected = selected ? 1 : 0 unless selected.is_a? Numeric #convert booleans to numbers
      translations[selected] || keys[selected] || keys.last
    end
  end

end
