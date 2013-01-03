package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached

object Posts extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Cached("posts", 1000) {
    Action {
      Async {
        for {
          titles <- Category.titles
          recent <- Post.recent
          archive <- Post.archive(recent.last.key)
        }
        yield Ok(views.html.Posts.index(recent.map(_.value), archive.map(_.value), titles))
      }
    }
  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO
}