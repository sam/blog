require "chronic"
require "stringex"

class Post

  def self.recent
    fetch(*config.redis.smembers("posts")[0,5])
  end

  def self.archive
    fetch(*config.redis.smembers("posts")[5,20])
  end
  
  def self.all
    fetch(*config.redis.smembers("posts"))
  end
  
  def self.get(slug)
    Post.new(config.redis.get("post-#{slug}"))
  end

  def initialize(value = nil)
    if value
      data = JSON::parse(value)
      @title = data["title"]
      @slug = data["slug"]
      @body = data["body"]
      @published_at = data["published_at"].blank? ? nil : Time::parse(data["published_at"])
      @categories = data["categories"]
    end
  end

  attr_accessor :title, :slug, :body, :published_at, :categories

  def errors
    @errors = {}
    
    if @title.blank?
      @errors[:title] = "Title must not be empty."
    end
    
    if !@published_at_raw.blank? && @published_at.blank?
      @errors[:published_at] = "Published At must be a valid date-time."
    end
    
    if @body.blank? && (!@published_at.blank? || !@published_at_raw.blank?)
      @errors[:body] = "You cannont publish an empty post."
    end
    
    @errors
  end
  
  def published_at=(value)
    @published_at_raw = value
    @published_at = Chronic.parse(value)
  end
  
  def published?
    !@published_at.blank?
  end
  
  def to_hash
    {
      "slug" => to_url,
      "title" => @title,
      "published_at" => @published_at,
      "body" => @body,
      "categories" => @categories
    }
  end

  def to_json
    to_hash.to_json
  end
  
  def to_url
    @slug ||= title.to_url
  end

  def save
    config.redis.set key, to_json
    config.redis.sadd "posts", key
  end
    
  private
  def key
    "post-#{to_url}"
  end
  
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