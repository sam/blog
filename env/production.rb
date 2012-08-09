# Make use of Tilt (https://github.com/rtomayko/tilt) cache for compiled templates
Harbor::View.cache_templates!

config.assets.compile = true

config.couchdb = "http://#{File.read(".couchdb").strip}@ssmoot.cloudant.com:5984/blog"