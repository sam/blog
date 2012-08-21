#!/usr/bin/env jruby

require "java"
require "rubygems"
require "bundler/setup" unless Object::const_defined?("Bundler")

require "singleton"

require "listen"

class Watcher
  include Singleton

  def initialize
    @interrupted = false

    # Hit Ctrl-C once to re-run all specs; twice to exit the program.
    Signal.trap("INT") do
      if @interrupted
        puts "\nShutting down..."
        exit
      else
        @interrupted = true
        run_all_specs
        @interrupted = false
      end
    end
  end

  def run
    # Output here just so you know when changes will be
    # picked up after you start the program.
    puts "Listening for changes..."
    listener.start
  end

  private
  def listener
    # Using a MultiListener here since the only
    # other way to watch both directories is to
    # create two listeners and start the first in
    # non-blocking mode so you can start the second.
    # Neither of these seems all that clean compared to
    # the original 'watchr' code, but it is fewer LOC,
    # it works, and you don't get annoying warnings so...
    @listener ||= Listen.to("test", "lib")
      .filter(/\.rb$/)
      .change do |modified, added, removed|
      modified.each do |path|
        # Filter because the ignore feature on Listener seems to
        # not work... Maybe a MultiListener issue?
        next unless path =~ /\/(lib\/.*|test\/.*_spec)\.rb$/
        relative_path_from_root = Pathname(path).relative_path_from(Pathname.pwd)
        run_single_spec relative_path_from_root.to_s.sub(/(_spec)?\.rb/, "").sub(/^(test|lib\/harbor\/ftp)\//, "")
      end
    end
  end

  def run_single_spec(underscored_name)  
    spec = Pathname("test/#{underscored_name}_spec.rb")

    if spec.exist?
      puts "\n --- Running #{spec.basename('.rb')} ---\n\n"
      begin
        org.jruby.Ruby.newInstance.executeScript <<-RUBY, spec.to_s
          require "#{spec}"
          MiniTest::Unit.new._run
        RUBY
      rescue => e
        puts e.to_s, e.backtrace.join("\n")
      end
    else
      puts "No matching spec for #{spec}"
    end
  end

  def run_all_specs
    puts "\n --- Running all specs ---\n\n"
    begin
      org.jruby.Ruby.newInstance.executeScript <<-RUBY, "all-specs"
        Dir["test/**/*_spec.rb"].each { |file| require file }
        MiniTest::Unit.new._run
      RUBY
    rescue => e
      puts e.to_s, e.backtrace.join("\n")
    end
  end
end

Watcher::instance.run