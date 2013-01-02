package models

import sprouch.JsonProtocol._
import java.util.Date
import play.api.libs.json.Json

case class Post(
                 title:Option[String],
                 body: Option[String],
                 slug: Option[String],
                 publishedAt: Option[Date]) {
  def categories = Nil
}

object Post extends Model {

  import sprouch._
  import ViewQueryFlag._
  implicit val postFormat = jsonFormat4(Post.apply)

  def recent = {
    withDb(_.queryView[(Long, String), Post]("posts", "all", flags = Set[ViewQueryFlag](descending), limit = Some(10)).map(_.rows.map { revedDoc =>
      Post(Json.parse(revedDoc.value) \ "doc")
    }))
  }

  def archive = recent
}