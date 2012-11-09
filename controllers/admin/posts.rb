class Blog
  class Admin
    class Posts < Harbor::Controller
      
      get "new" do
        @post = ::Post.new
        render "admin/posts/edit"
      end
      
      get ":slug/edit" do |slug|
        @post = ::Post.db.get_by_slug slug
        render "admin/posts/edit"
      end
      
      post do |title, published_at, body, categories, _id = nil|
        @post = _id.blank? ? Post.new : Post.db.get_by_id(_id)
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
        Post.db.delete(id)
        response.redirect "/admin"
      end
      
    end
  end
end
