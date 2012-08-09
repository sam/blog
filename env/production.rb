# Make use of Tilt (https://github.com/rtomayko/tilt) cache for compiled templates
Harbor::View.cache_templates!

config.couchdb = "http://#{File.read(".couchdb")}@ssmoot.cloudant.com/blog"