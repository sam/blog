class Category
  def self.titles
  	DB.view("posts/categories", group: true)["rows"].map { |h| h["key"] }
  end
end