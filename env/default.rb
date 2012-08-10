require "java"
require "json"
require "couchrest"

### BEGIN: Hazelcast Configuration
require_relative "../lib/hazelcast-2.2.jar"
java_import com.hazelcast.core.Hazelcast
java_import com.hazelcast.config.Config

at_exit { Hazelcast.shutdown_all }

config.hazelcast = Java::ComHazelcastConfig::Config.new
config.hazelcast.set_port 5700
config.hazelcast.set_port_auto_increment false

network = config.hazelcast.get_network_config
join = network.get_join
join.get_multicast_config.set_enabled false
join.get_tcp_ip_config.set_required_member("127.0.0.1").set_enabled true
network.get_interfaces.set_enabled(true).add_interface "127.0.0.1"

cache_config = Java::ComHazelcastConfig::MapConfig.new
cache_config.set_name "cache"
cache_config.set_backup_count 0
config.hazelcast.add_map_config cache_config

CACHE = config.cache = Hazelcast.get_map "cache"

### END: Hazelcast Configuration

### Application's root path
# If you are developing a port you should use Blog.root outside
# config / env files as it will be overwritten by other ports and main app
config.root = Pathname(__FILE__).dirname.parent

Harbor::View::paths.unshift(config.root + "views")
Harbor::View::layouts.default("layouts/application")

### View helpers:
# Harbor will register all helpers from all applications on Harbor::ViewContext
# when it boots and this allow Harbor::ViewHelpers to find them. (config.helpers
# is an instance of it)
config.helpers.paths << config.root + "helpers/**/*.rb"

### Autoloader:
# Harbor will autoload your application code based on some conventions, but you
# can add other paths for your code to be found. (see Harbor::Autoloader for
# more information)
#
#   config.autoloader.paths << config.root + "some/path"

### Assets:
# Harbor uses Sprockets gem for serving and compiling assets and by default it
# will compile automatically development and test environments. For production
# you'll have to run "harbor assets" when deploying to compile and compress all
# assets from ports and application itself to the public folder.
#
# For more information check Harbor::Assets

config.assets.append_path config.root + "assets/javascripts"
config.assets.append_path config.root + "assets/stylesheets"

config.assets.compress = true

config.assets.precompiled_assets = %w( application.js application.css )

### Console setup:
# If you would like to use Pry (http://pry.github.com/) instead
# of IRB for your console, uncomment the configuration line below.
#
#  config.console = Harbor::Consoles::Pry
#
# Don't forget to add the following to your Gemfile and rebundle!
#
#  gem "pry"

### Template Caching:
# If you would like to enable Tilt (https://github.com/rtomayko/tilt) caching
# for all environments, uncomment the configuration line below and remove the
# same line from env/production.rb and env/stage.rb but be aware that you'll
# need to restart the app to see template changes while developing
#
#  Harbor::View.cache_templates!

config.couchdb = "http://localhost:5984/blog"