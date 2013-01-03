package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached

object Posts extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Cached("posts", 60) {
    ActionWithCategories { implicit categories => request =>
      Async {
        for {
          recent <- Post.recent
          archive <- Post.archive(recent.keys.last)
        }
        yield Ok(views.html.Posts.index(recent.docs[Post], archive.values))
      }
    }
  }

  def show(slug: String) = Cached("posts." + slug, 60) {
    ActionWithCategories { implicit categories => request =>
      Async {
        for(post <- Post.getBySlug(slug))
        yield post.map { post =>
          Ok(views.html.Posts.show(post))
        }.getOrElse(NotFound)
      }
    }
  }

  def create = TODO

  def delete(id: String) = TODO

  private def ActionWithCategories(action:Seq[String] => Request[AnyContent] => Result): Action[AnyContent] = {
    Action { request =>
      Async {
        for(categories <- Category.titles)
        yield action(categories)(request)
      }
    }
  }
}