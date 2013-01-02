package controllers

import play.api.mvc._
import models._
import play.Logger
import play.api.libs.ws.WS
import play.libs.WS.Response
import spray.http.DateTime
import java.util.Date

object Posts extends Controller with AkkaExecutionContext {
  import akkaSystem.dispatcher

  def index = Action {
    Async {
      for {
        titles <- Category.titles
//        recent <- WS.url("http://ssmoot.cloudant.com/blog/_design/posts/_view/all?limit=10&descending=true&include_docs=true").get.map { response =>
//          (response.json \\ "doc").map { json =>
//            Post(
//              title = (json \ "title").as[String],
//              body = (json \ "body").as[String],
//              slug = (json \ "slug").as[String],
//              publishedAt = (json \ "published_at").asOpt[Date]
//            )
//          }
//        }
        recent <- Post.recent
        archive <- Post.archive
      }
      yield {
        Ok(views.html.Posts.index(recent, archive, titles))
      }
    }
  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO

}