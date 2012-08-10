require "rubygems"
require "bundler/setup"
require "harbor"
require "json"
require_relative "hazelcast-2.2.jar"

Bundler.require(:default, config.environment.to_sym)

config.load!(Pathname(__FILE__).dirname.parent + "env")

DB = CouchRest.database(config.couchdb)

class CouchRest::Document
  def to_map
    to_hash.to_map
  end
end

class Hash
  def to_map
    java.util.HashMap.new self
  end
end  

java_import com.hazelcast.core.Hazelcast
at_exit { Hazelcast.shutdown_all }

CACHE = Hazelcast.get_map "cache"

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