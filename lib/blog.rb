require "rubygems"
require "doubleshot/setup"

require "lib/harbor/lib/harbor"

require "json"
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
