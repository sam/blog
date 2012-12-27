package models

import sprouch._
import sprouch.JsonProtocol._

case class Category(title:String)

object Category {
  def titles = Seq("One", "Two", "Three")

//  def titles
//  @cache.get("categories") do
//  COUCH.view("posts/categories", group: true)["rows"].map { |row| row["key"] }
//  end
//  end
}