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

  helpers do
    def date_to_string(date)
      date.strftime("%d %b %Y")
    end
    
    def error_for?(object, field)
      if request.post? && object.errors.key?(field)
        " error"
      end
    end
  end
  
  get "/" do
    @posts = Post.recent
    @archives = Post.archive
    @categories = Category.titles
    erb :index
  end

  get "/posts/new" do
    @post = Post.new
    erb :post
  end
  
  get "/posts/:slug/edit" do
    @post = Post.get params[:slug]
    erb :post
  end
  
  get "/posts/:slug" do
    @post = Post.get params[:slug]
    erb :show
  end
  
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

  get "/admin" do
    if authenticated?
      @posts = Post.all
      erb :admin
    else
      erb :login
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if session["auth"] = Admin.authenticate(params["email"], params["password"], nil)
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
