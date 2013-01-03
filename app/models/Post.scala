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
    withDb(_.queryView[(Long, String), Post]("posts", "all", flags = Set[ViewQueryFlag](descending), limit = Some(10)).map(_.rows))
  }

  def archive(startKey:(Long, String)) = {
    import spray.json._

    // TODO: This is a Hack to get the project to compile,
    // but the beahavior is not correct. The JSON Array is
    // doubly-escaped by Sprouch so the query fails to begin
    // returning results at the actual startKey.
    // (It starts at the beginning.)
    //
    // When https://github.com/KimStebel/sprouch/issues/8
    // is resolved, the following val should be removed,
    // and the ultimate fix applied.
    val _startKey = startKey.toJson.toString
    withDb(_.queryView[(Long, String), Post]("posts", "archive", flags = Set[ViewQueryFlag](descending), keyDocIdRange = Some(_startKey, ""), skip = Some(1)).map(_.rows))
  }

  def getBySlug(slug:String) = {
    withDb(_.queryView[String, Post]("posts", "slugs", flags = Set[ViewQueryFlag](include_docs, inclusive_end), key = Some(slug)).map(_.rows.map(_.value).headOption))
  }
}