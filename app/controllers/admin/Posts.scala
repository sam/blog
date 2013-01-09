package controllers.admin

import play.api.mvc._
import models._
import controllers.{admin, Secured}
import concurrent.Await
import play.api.cache.Cache
import java.util.Date

object Posts extends Secured {
  import play.api.Play.current
  import akkaSystem.dispatcher
  import concurrent.duration._

  def index = withAuth { username => implicit request =>
    Async {
      for {
        posts <- Post.all
        categories <- Category.titles
      }
      yield Ok(views.html.admin.Posts.index(posts.docs[Post])(categories, flash))
    }
  }

  def create = withAuth { username => implicit request =>
    Async {
      for(categories <- Category.titles)
      yield postForm.bindFromRequest.fold(
        errors => BadRequest(views.html.admin.Posts.edit(errors)(categories)),
        post => {
          Await.result(Post.create(post), 5 seconds)
          Cache.set("modifiedAt", new Date().getTime)
          Redirect(admin.routes.Posts.index).flashing("success" -> s"""Post "${post.title}" successfully CREATED.""")
        }
      )
    }
  }

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

  def preview = Action { implicit request =>
    import helpers.Markdown._
    request.body.asFormUrlEncoded.map { data =>
      Ok(markdownToHtml(data("body").head))
    }.getOrElse(BadRequest("Preview requires an encoded Form"))
  }

  def update(id:String) = withAuth { username => implicit request =>
    Async {
      for(categories <- Category.titles)
      yield postForm.bindFromRequest.fold(
        errors => BadRequest(views.html.admin.Posts.edit(errors)(categories)),
        post => {
          Await.result(Post.update(id, post), 5 seconds)
          Cache.set("modifiedAt", new Date().getTime)
          Redirect(admin.routes.Posts.index).flashing("success" -> s"""Post "${post.title}" successfully UPDATED.""")
        }
      )
    }
  }

  def delete(id: String) = withAuth { username => implicit request =>
    Async {
      for((_, post) <- Post.delete(id))
      yield {
        Cache.set("modifiedAt", new Date().getTime)
        Redirect(routes.Posts.index).flashing("success" -> s"""Post "${post.data.title}" successfully DELETED.""")
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