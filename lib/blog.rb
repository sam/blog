require "rubygems"
require "bundler/setup"
require "harbor"
require "json"

Bundler.require(:default, config.environment.to_sym)

config.load!(Pathname(__FILE__).dirname.parent + "env")

DB = CouchRest.database(config.couchdb)

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