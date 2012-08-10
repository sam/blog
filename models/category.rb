class Category
  def self.titles
    CACHE["categories"] ||= begin
  	  DB.view("posts/categories", group: true)["rows"].map { |h| h["key"] }
  	end
  end
end