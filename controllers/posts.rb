class Blog
  class Posts < Harbor::Controller

    get "/" do
      @posts = Post.recent
      @archives = Post.archive(@posts.last.key)
      @categories = Category.titles
      render "home/index"
    end
  end
end
