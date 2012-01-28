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
    erubis :index
  end

  get "/posts/new" do
    erubis :post
  end

  get "/admin" do
    if authenticated?
      erubis :admin
    else
      erubis :login
    end
  end

  get "/login" do
    erubis :login
  end

  post "/login" do
    if session["auth"] = Admin.authenticate(params["email"], params["password"], params["token"])
      redirect to("/admin")
    else
      erubis :login
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