package models

import java.util.Date

case class Post(
                 title:Option[String],
                 body: Option[String],
                 slug: Option[String],
                 publishedAt: Option[Date],
                 categories: Option[Seq[String]])

object Post extends Model {

  import sprouch._
  import sprouch.JsonProtocol._

  import ViewQueryFlag._
  implicit val postFormat = jsonFormat5(Post.apply)

  def recent = {
    withDb(_.queryView[(Long, String), Null]("posts", "all", flags = Set[ViewQueryFlag](descending, include_docs), limit = Some(10)))
  }

  def archive(startKey:(Long, String)) = {
    import spray.json._

    withDb(_.queryView[(Long, String), Post]("posts", "archive", flags = Set[ViewQueryFlag](descending), startKey = Some(startKey), skip = Some(1)))
  }

  def getBySlug(slug:String) = {
    withDb(_.queryView[String, Null]("posts", "slugs", flags = Set[ViewQueryFlag](include_docs, inclusive_end), key = Some(slug)).map(_.docs[Post].headOption))
  }
}