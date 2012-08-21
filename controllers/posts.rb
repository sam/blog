class Blog
  class Posts < Harbor::Controller

    get "/" do
      @posts = Post.db.recent
      @archives = Post.db.archive(@posts.last.key)
      @categories = Category.titles
      render "posts/index"
    end
    
    get "/posts/:slug" do |slug|
      @post = Post.db.get_by_slug slug
      render "posts/show"
    end
    
  end
end
