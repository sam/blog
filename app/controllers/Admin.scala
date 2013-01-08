package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached

object Admin extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Action {
    Async {
      for(posts <- Post.all)
      yield Ok(views.html.Admin.index(posts.docs[Post]))
    }
  }
}