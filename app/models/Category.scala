package models

import sprouch.{Database, JsonProtocol}

case class Category(title:String)

object Category extends Model {

  import JsonProtocol._

//  def query[K,V](view: Database => JsonProtocol.ViewResponse[K,V], process:JsonProtocol.ViewResponse[K,V] => Any) = {
//    for {
//      db <- couch.getDb("blog")
//      result <- view(db)
//    } yield process(result)
//  }

  def titles = {
    for {
      db <- couch.getDb("blog")
      result <- db.queryView[String, Null]("posts", "categories", groupLevel = Some(1))
    } yield result.rows.map(_.key)
  }
}