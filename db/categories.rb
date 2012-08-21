class Category
  class Db < CachedDatabase
    def titles
      @cache.get("categories") do
        COUCH.view("posts/categories", group: true)["rows"].map { |row| row["key"] }
      end
    end
  end
end