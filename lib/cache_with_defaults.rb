class CacheWithDefaults
  def initialize(cache)
    @cache = cache
  end
      
  def get(key)
    @cache[key] ||= yield
  end
  
  def delete(key)
    @cache.delete(key)
  end
end