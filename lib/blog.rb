require "java"
require "rubygems"
require "bundler/setup" unless Object::const_defined?("Bundler")
require "harbor"
require "json"
Dir["target/dependency/*.jar"].each { |jar| require jar }

require "models/model"
require "db/cached_database"

config.load!(Pathname(__FILE__).dirname.parent + "env")

COUCH = CouchRest.database(config.couchdb)

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