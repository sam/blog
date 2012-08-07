$: << File.dirname(__FILE__)
require "bundler/setup"
require "configuration"
require "blank"

def config
  @config ||= Configuration.new
end

require "sinatra/base"
require "erubis"
require "redcloth"

require "admin"
require "post"
require "category"

class Blog < Sinatra::Base

  set :root, (File.dirname(__FILE__) + "/..")
  set :erb, :escape_html => true
  enable :sessions
    
  post "/posts" do
    @post = Post.new
    @post.title = params[:title]
    @post.published_at = params[:published_at]
    @post.body = params[:body]
    @post.categories = params[:categories]
    if @post.errors.empty?
      @post.save
      erb :post
    else
      erb :post
    end
  end
end