class Cache
  def initialize(cache)
    @cache = cache
  end
      
  def get(key)
    @cache[key] ||= yield
  end
end