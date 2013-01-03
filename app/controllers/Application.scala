package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached
import forms._

object Application extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def login = Cached("login") {
    Action {
      Ok(views.html.Application.login(Login.form))
    }
  }

  def submit = TODO
}