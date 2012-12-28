package controllers

import play.api.mvc._
import models._
import play.api.libs.ws.WS
import play.api.libs.concurrent.Akka

object Posts extends Controller {

  def index = Action {
    Async {
      import play.api.Play.current
      val akkaSystem = Akka.system
      import akkaSystem.dispatcher

      Category.titles.map { titles =>
        Ok(views.html.Posts.index(Post.recent, Post.archive, titles))
      }
    }


  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO

}