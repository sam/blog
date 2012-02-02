class Category
  def self.titles
    config.redis.smembers "categories" || []
  end
end