class Blog
  class Admin < Harbor::Controller
  
    get do
      if authenticated?
        @posts = Post.db.all
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
