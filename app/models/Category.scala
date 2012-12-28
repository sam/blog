package models

import sprouch.JsonProtocol._

case class Category(title:String)

object Category {

  def titles = Seq("One", "Two", "Three")

  def titles2 = {
    implicit val categoryFormat = jsonFormat3(Category)

    for(db <- couch.getDb("blog")) yield {
      db.queryView("_design/posts", "categories") {
        groupLevel = 1
      }
    }
  }

//  def titles
//  @cache.get("categories") do
//  COUCH.view("posts/categories", group: true)["rows"].map { |row| row["key"] }
//  end
//  end
}