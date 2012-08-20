require "chronic"

class Post
  class Db < CachedDatabase
    def recent
      @cache.get("posts/recent") do
        COUCH.view("posts/all", descending: true, limit: 10)["rows"].map { |row| Post.new(row["value"].merge("key" => row["key"])) }
      end
    end
    
    def archive(startkey)
      @cache.get("posts/archive") do
        COUCH.view("posts/archive", descending: true, startkey: startkey, skip: 1)["rows"].map do |row|
          Post.new(row["value"].merge("key" => row["key"]))
        end
      end
    end
    
    def all
      @cache.get("all") do
        COUCH.view("posts/all", descending: true)["rows"].map { |row| Post.new(row["value"].merge("key" => row["key"])) }
      end
    end
    
    def get_by_slug(slug)
      @cache.get("posts/slug/#{slug}") do
        if value = COUCH.view("posts/slugs", key: slug)["rows"].first
          Post.new(value["value"])
        else
          nil
        end
      end
    end
    
    def get_by_id(id)
      @cache.get("posts/id/#{id}") do
        if value = COUCH.view("posts/by_id", key: id)["rows"].first
          Post.new(value["value"])
        else
          nil
        end
      end
    end
    
    def delete(id)
      if value = COUCH.view("posts/by_id", key: id)["rows"].first
        rev = value["value"]["_rev"]
        COUCH.delete_doc("_id" => id, "_rev" => rev) if rev
        @cache.clear
      else
        raise StandardError.new("Document Not Found for _id: #{id}")
      end
    end
    
    def create(post)
      COUCH.save_doc({
        "title"         => post.title,
        "published_at"  => (post.published_at ? post.published_at.httpdate : nil),
        "body"          => post.body,
        "categories"    => post.categories,
        "slug"          => post.slug
      })
      @cache.clear
    end
    
    def update(post)
      COUCH.update_doc post._id do |doc|
        doc["slug"]           = post.slug
        doc["title"]          = post.title
        doc["published_at"]   = (post.published_at ? post.published_at.httpdate : nil)
        doc["body"]           = post.body
        doc["categories"]     = post.categories
      end
      @cache.clear
    end

  end
end