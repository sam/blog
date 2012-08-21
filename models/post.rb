require "stringex"
require "pp"

class Post
  include Model

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