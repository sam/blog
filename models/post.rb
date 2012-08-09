require "chronic"
require "stringex"

class Post

  def self.recent
    DB.view("posts/all", descending: true, limit: 10)["rows"].map { |row| Post.new(row["key"], row["value"]) }
  end
  
  def self.archive(startkey)
    DB.view("posts/archive", descending: true, startkey: startkey, skip: 1)["rows"].map { |row| Post.new(row["key"], row["value"]) }
  end
  
  def self.all
    DB.view("posts/all", descending: true)["rows"].map { |row| Post.new(row["key"], row["value"]) }
  end
  
  def self.get_by_slug(slug)
    if value = DB.view("posts/slugs", key: slug)["rows"].first
      Post.new(value["id"], value["value"])
    else
      nil
    end
  end
  
  def self.get_by_id(id)
    if value = DB.view("posts/by_id", key: id)["rows"].first
      Post.new(value["id"], value["value"])
    else
      nil
    end
  end
  
  def self.delete(id)
    if value = DB.view("posts/by_id", key: id)["rows"].first
      rev = value["value"]["_rev"]
      DB.delete_doc("_id" => id, "_rev" => rev) if rev
    else
      raise StandardError.new("Document Not Found for _id: #{id}")
    end
  end
  
  def self.update(id, title, published_at, body, categories)
    if id.blank?
      post = Post.new nil,
        "title"         => title,
        "published_at"  => published_at,
        "body"          => body,
        "categories"    => categories

      attributes = post.to_hash
      attributes["published_at"] = attributes["published_at"].httpdate if attributes["published_at"]
      
      DB.save_doc attributes if post.errors.empty?
      post
    else
      post = get_by_id(id)
      post.title = title
      post.published_at = published_at
      post.body = body
      post.categories = categories
      
      if post.errors.empty?
        DB.update_doc id do |doc|
          doc["slug"]           = post.to_url
          doc["title"]          = post.title
          doc["published_at"]   = post.published_at.httpdate
          doc["body"]           = post.body
          doc["categories"]     = post.categories
        end
      end
      
      post
    end
  end
  
  def initialize(key = nil, value = nil)
    if value
      @key = key
      @title = value["title"]
      @slug = value["slug"]
      @body = value["body"]
      @published_at = value["published_at"].blank? ? nil : Chronic::parse(value["published_at"]) || Time::parse(value["published_at"])
      @categories = value["categories"]
    end
  end

  attr_accessor :title, :slug, :body, :published_at, :categories, :key

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
  
  def inspect
    "#<Post: _id:#{@key}, slug=#{@slug.inspect}, published_at=#{@published_at}, categories=#{@categories.inspect}, title=#{@title.inspect}, body=#{@body.inspect}>"
  end
  
  def to_url
    @slug ||= title.to_url
  end
end