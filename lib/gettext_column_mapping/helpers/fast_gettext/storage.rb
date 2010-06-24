module FastGettext
  module Storage

    def cached_plural_find_with_name_space(*keys)
      key = '||||' + keys * '||||'
      translation = current_cache[key]
      return translation if translation or translation == false #found or was not found before
      current_cache[key] = current_repository.plural_with_namespace(*keys) || false
    end

  end
end
