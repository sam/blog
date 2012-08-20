class Blog
  class Admin < Harbor::Controller
  
    get do
      if authenticated?
        @posts = Post.all
        render "admin/index"
      else
        render "admin/login"
      end
    end
    
    get "/login" do
      render "admin/login"
    end

    post "/login" do |email, password|
      if request.session["auth"] = ::Admin.authenticate(email, password, nil)
        response.redirect("/admin")
      else
        @error = true
        render "admin/login"
      end
    end
    
    class Posts < Harbor::Controller
      
      get "new" do
        @post = ::Post.new
        render "admin/posts/edit"
      end
      
      get ":slug/edit" do |slug|
        @post = ::Post.get_by_slug slug
        p @post
        render "admin/posts/edit"
      end
      
      post do |title, published_at, body, categories, _id = nil|
        @post = _id.blank? ? Post.new : Post.get_by_id(_id)
        @post.title = title
        @post.published_at = published_at
        @post.body = body
        @post.categories = categories.split(/,?\s+/)
        
        if @post.errors.empty?
          @post.save
          response.redirect "/admin"
        else
          render "admin/posts/edit"
        end
      end
      
      get ":id/delete" do |id|
        Post.delete(id)
        response.redirect "/admin"
      end
      
    end
    
    private
    def authenticated?
      if token = request.session["auth"]
        ::Admin.authenticate(nil, nil, token)
      else
        nil
      end
    end    
  end
end