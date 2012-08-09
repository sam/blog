class Blog
  class Posts < Harbor::Controller

    get "/" do
      @posts = Post.recent
      @archives = Post.archive(@posts.last.key)
      @categories = Category.titles
      render "posts/index"
    end
    
    get "/posts/:slug" do |slug|
      @post = Post.get_by_slug slug
      render "posts/show"
    end
    
  end
end
