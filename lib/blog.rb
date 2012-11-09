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

require "controllers/posts"
require "controllers/admin"
require "controllers/admin/posts"

Dir[config.root + 'models/*.rb'].each do |controller|
  require controller
end
