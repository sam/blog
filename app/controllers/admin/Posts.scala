package controllers.admin

import play.api.mvc._
import models._
import controllers.Secured

object Posts extends Secured {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = withAuth { username => implicit request =>
    Async {
      for {
        posts <- Post.all
        categories <- Category.titles
      }
      yield Ok(views.html.admin.Posts.index(posts.docs[Post])(categories, flash))
    }
  }

  def create = TODO

  def newPost = withAuth { username => implicit request =>
    Async {
      for(categories <- Category.titles)
      yield Ok(views.html.admin.Posts.edit(postForm)(categories))
    }
  }

  def edit(id:String) = withAuth { username => implicit request =>
    Async {
      for {
        post <- Post.getById(id)
        categories <- Category.titles
      }
      yield post.map { post =>
        Ok(views.html.admin.Posts.edit(postForm.fill(post))(categories))
      }.getOrElse(NotFound)
    }
  }

  def update(id:String) = TODO

  def delete(id: String) = withAuth { username => implicit request =>
    Async {
      for {
        categories <- Category.titles
        posts <- Post.all
        (_, post) <- Post.delete(id)
      }
      yield {
        Redirect(routes.Posts.index).flashing("success" -> s"""Post "${post.data.title}" successfully deleted.""")
      }
    }
  }

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