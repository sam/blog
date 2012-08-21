class Category
  include Model
  
  def self.titles
    self.db.titles
  end
end