require "rubygems"
require "bundler/setup" unless Object::const_defined?("Bundler")

require "ffaker"

require "minitest/autorun"
require "minitest/pride"
require "minitest/wscolor"

$:.unshift (Pathname(__FILE__).dirname.parent + "lib").to_s
require "boot"

require "sequel"

require "thread"
require "fileutils"

class Helper

  @semaphore = Mutex.new

  def self.semaphore
    @semaphore
  end
end