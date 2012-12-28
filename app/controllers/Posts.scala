package controllers

import play.api.mvc._
import models._
import play.api.libs.ws.WS
import play.api.libs.concurrent.Akka

object Posts extends Controller {

  def index = Action {
    import play.api.Play.current
    val akkaSystem = Akka.system
    import akkaSystem.dispatcher

    Async {
      WS.url("http://127.0.0.1:5984/blog/_design/posts/_view/categories?group=true").get().map { response =>
        val categories = (response.json \ "rows" \\ "key").map(_.as[String])

        Ok(views.html.Posts.index(Post.recent, Post.archive, categories))
      }
    }


  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO

}