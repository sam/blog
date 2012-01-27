class Post
  
  def self.recent
    fetch(*config.redis.lrange("posts", 0, 5))
  end
  
  def self.archive
    fetch(*config.redis.lrange("posts", 5, 20))
  end
  
  def initialize(value = nil)
    if value
      data = JSON::parse(value)
      @title = data["title"]
      @slug = data["slug"]
      @body = data["body"]
      @published_at = data["published_at"]
      @categories = data["categories"]
    end
  end
  
  attr_accessor :title, :slug, :body, :published_at, :tags
  
  private
  def self.fetch(*keys)
    if keys.empty?
      []
    else
      config.redis.mget(*keys).map do |value|
        Post.new(value)
      end
    end
  end
end