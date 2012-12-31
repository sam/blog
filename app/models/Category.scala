package models

import sprouch.{ViewQueryFlag, JsonProtocol}

case class Category(title:String)

object Category extends Model {

  import JsonProtocol._

  def titles = {
    withDb(_.queryView[String, Null]("posts", "categories", flags = ViewQueryFlag(group = true)).map(_.rows.map(_.key)))
  }
}