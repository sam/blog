package controllers

import play.api.mvc._
import play.api.mvc.Security._
import models._
import play.api.cache.{Cache, Cached}
import concurrent.Await

object Posts extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Cached(s"${Cache.get("modifiedAt").getOrElse(0)}-posts", 60) {
    Action {
      Async {
        for {
          recent <- Post.recent
          archive <- Post.archive(recent.keys.last)
          categories <- Category.titles
        }
        yield Ok(views.html.Posts.index(recent.docs[Post], archive.values)(categories))
      }
    }
  }

  def show(slug: String) = Cached(s"${Cache.get("modifiedAt").getOrElse(0)}-posts-$slug", 60) {
    Action {
      Async {
        for {
          post <- Post.getBySlug(slug)
          categories <- Category.titles
        }
        yield post.map { post =>
          Ok(views.html.Posts.show(post)(categories))
        }.getOrElse(NotFound)
      }
    }
  }
}