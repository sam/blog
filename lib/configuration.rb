require "redis"

class Configuration
  
  def initialize
    @redis = Redis.new
  end
  
  attr_reader :redis
end