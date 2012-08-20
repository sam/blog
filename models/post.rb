require "stringex"
require "pp"

require "models/post/db"

class Post
  include Model

  def self.recent
    self.db.recent
  end
  
  def self.archive(startkey)
    self.db.archive(startkey)
  end
  
  def self.all
    self.db.all
  end
  
  def self.get_by_slug(slug)
    self.db.get_by_slug(slug)
  end
  
  def self.get_by_id(id)
    self.db.get_by_id(id)
  end
  
  def self.delete(id)
    self.db.delete(id)
  end

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
    @published_at = self.class.typecast_time(value)
  end
  
  def published?
    !@published_at.blank? && @published_at < Time::now
  end
  
  def to_url
    @slug ||= title.to_url
  end
  
  def slug
    to_url
  end
end