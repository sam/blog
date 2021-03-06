package models

import java.util.Date
import concurrent.Await

case class Post(
                 _id:Option[String],
                 title:String,
                 slug: String,
                 publishedAt: Option[Date],
                 body: Option[String],
                 categories: Option[Seq[String]]) {

  def isPublished = publishedAt.map(_.before(new Date())).getOrElse(false)
}

object Post extends Model {

  import sprouch._
  import sprouch.JsonProtocol._

  import ViewQueryFlag._
  import concurrent.duration._
  import sprouch.dsl._

  implicit val postFormat = jsonFormat6(Post.apply)

  def all = {
    withDb(_.queryView[(Option[Long], String), Null]("posts", "all", flags = Set[ViewQueryFlag](descending, include_docs)))
  }

  def recent = {
    withDb(_.queryView[(Long, String), Null]("posts", "recent", flags = Set[ViewQueryFlag](descending, include_docs), limit = Some(10)))
  }

  def archive(startKey:(Long, String)) = {
    withDb(_.queryView[(Long, String), Post]("posts", "archive", flags = Set[ViewQueryFlag](descending), startKey = Some(startKey), skip = Some(1)))
  }

  def getBySlug(slug:String) = {
    withDb(_.queryView[String, Null]("posts", "slugs", flags = Set[ViewQueryFlag](include_docs, inclusive_end), key = Some(slug)).map(_.docs[Post].headOption))
  }

  def getById(id:String) = {
    withDb(_.queryView[String, Null]("posts", "by_id", flags = Set[ViewQueryFlag](include_docs, inclusive_end), key = Some(id)).map(_.docs[Post].headOption))
  }

  def create(post:Post) = {
    for(doc <- withDb(_.createDoc(post)))
    yield doc
  }

  def update(id:String, post:Post) = {
    for(doc <- get[Post](id))
    yield doc := post
  }

  def delete(id:String) = {
    for {
      post <- withDb(_.getDoc[Post](id))
      result <- withDb(_.deleteDoc(post))
    } yield (result, post)
  }
}