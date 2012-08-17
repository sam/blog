require "java"
require "rubygems"
require "bundler/setup"
require "harbor"
require "json"
Dir["target/dependency/*.jar"].each { |jar| require jar }

require "cache"

Bundler.require(:default, config.environment.to_sym)

config.load!(Pathname(__FILE__).dirname.parent + "env")

DB = CouchRest.database(config.couchdb)

java_import org.infinispan.Cache
java_import org.infinispan.manager.DefaultCacheManager

CACHE = DefaultCacheManager.new.get_cache

class Blog < Harbor::Application

  def initialize
  end

end

Dir[config.root + 'controllers/*.rb'].each do |controller|
  require controller
end

Dir[config.root + 'models/*.rb'].each do |controller|
  require controller
end