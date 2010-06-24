module FastGettext
  class MoFile
    #returns the plural forms or all singular translations that where found
    def plural_with_namespace(seperator=nil, *msgids)
      translations = plural_translations(msgids)
      return translations unless translations.empty?
      msgids.map{|msgid| self[msgid] || msgid.split(seperator||NAMESPACE_SEPERATOR).last } #try to translate each id
    end

  end
end
