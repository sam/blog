package controllers

import play.api.mvc._
import play.api.mvc.Security._
import models._
import play.api.cache.Cached
import concurrent.Await

object Posts extends Secured {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Cached("posts", 60) {
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

  def show(slug: String) = Cached("posts." + slug, 60) {
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

  def create = TODO

  def edit(id:String) = withAuth { username => implicit request =>
    Async {
      for {
        post <- Post.getById(id)
        categories <- Category.titles
      }
      yield post.map { post =>
        Ok(views.html.Posts.edit(postForm.fill(post))(categories))
      }.getOrElse(NotFound)
    }
  }

  def update(id:String) = TODO

  def delete(id: String) = TODO

  import play.api.data.Form
  import play.api.data.Forms._

  val postForm = Form[Post](
    mapping(
      "title" -> nonEmptyText,
      "slug" -> nonEmptyText,
      "publishedAt" -> optional(date("yyyy-MM-dd")),
      "body" -> optional(text),
      "categories" -> list(text)
    )
    ((title, slug, publishedAt, body, categories) => Post(None, title, slug, publishedAt, body, Some(categories)))
    ((post: Post) => Some((post.title, post.slug, post.publishedAt, post.body, post.categories.getOrElse(Nil).toList)))
  )
}