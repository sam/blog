package controllers

import play.api.mvc._
import models._

object Posts extends Controller with AkkaExecutionContext {
  import akkaSystem.dispatcher

  def index = Action {
    Async {
      for {
        titles <- Category.titles
        recent <- Post.recent
        archive <- Post.archive(recent.last.key)
      }
      yield Ok(views.html.Posts.index(recent.map(_.value), archive.map(_.value), titles))
    }
  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO
}