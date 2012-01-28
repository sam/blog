$: << File.dirname(__FILE__)
require "bundler/setup"
require "configuration"

def config
  @config ||= Configuration.new
end

require "sinatra/base"
require "erubis"

require "admin"
require "post"
require "category"

class Blog < Sinatra::Base

  set :erubis, :escape_html => true
  enable :sessions
  
  get "/" do
    @posts = Post.recent
    @archives = Post.archive
    @categories = Category.titles
    erb :index
  end
  
  get "/posts/new" do
    erb :post
  end
  
  get "/admin" do
    if authenticated?
      erb :admin
    else
      erb :login
    end
  end
  
  get "/login" do
    erb :login
  end
  
  post "/login" do
    if session["auth"] = Admin.authenticate(params["email"], params["password"], params["token"])
      redirect to("/admin")
    else
      @error = true
      erb :login
    end
  end
  
  private
  def authenticated?
    if session["auth"]
      Admin.authenticate(nil, nil, session["auth"])
    else
      nil
    end
  end
end