class Category
  def self.titles
    config.redis.hkeys "categories" || []
  end
end