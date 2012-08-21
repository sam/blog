require "rubygems"
require "bundler/setup" unless Object::const_defined?("Bundler")

require "ffaker"

require "minitest/autorun"
require "minitest/pride"
require "minitest/wscolor"

ENV["ENVIRONMENT"] = "test"

$:.unshift (Pathname(__FILE__).dirname.parent + "lib").to_s

require "boot"

# A hold-over from a copy/paste from another project.
# Might come in handy here as I flesh out the test suite.
# class Helper
# 
#   @semaphore = Mutex.new
# 
#   def self.semaphore
#     @semaphore
#   end
# end