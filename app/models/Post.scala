package models

import sprouch.ViewQueryFlag
import sprouch.JsonProtocol._
import java.util.Date
import play.api.libs.json.{JsObject, JsString, JsValue, Format}
import spray.json.JsonFormat

case class Post(
                 title:String,
                 body:String,
                 slug: String,
                 publishedAt: Option[Date]) {
  def categories = Nil
}

object Post2 extends Model {

  implicit object PostFormat extends JsonFormat[Post] {

    implicit object DateFormat extends Format[java.util.Date] {
      val format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
      def reads(json:JsValue): java.util.Date = format.parse(json.as[String])
      def writes(date:java.util.Date) = JsString(format.format(date))
    }

    override def read(json: JsValue): Post = Post(
      (json \ "title").as[String],
      (json \ "body").as[String],
      (json \ "slug").as[String],
      (json \ "published_at").asOpt[java.util.Date]
    )

    override def write(post: Post) =
      new spray.json.JsValue(
        Seq(
          "title" -> JsString(post.title.toString),
          "body" -> JsString(post.body.toString),
          "slug" -> JsString(post.slug.toString),
          "published_at" -> JsString(post.publishedAt.toString)
        )
      )
  }

  def recent = {
    withDb(_.queryView[(Long, String), Post]("posts", "all", flags = ViewQueryFlag(descending = true, include_docs = true), limit = Some(10)).map(_.rows.map(_.value)))
  }

  def archive = recent
}