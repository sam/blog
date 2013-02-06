package controllers

import play.api.mvc._
import models._
import concurrent.Future

object Application extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def login = Action {
    Ok(views.html.Application.login(loginForm))
  }

  def submitLogin = Action { implicit request =>
    Async {
      val bound = loginForm.bindFromRequest
      bound.fold(
        errors => Future.successful(BadRequest(views.html.Application.login(errors))),
        value => User.authenticate(value._1, value._2).collect {
          case None => BadRequest(views.html.Application.login(bound.withGlobalError("Invalid email or password!")))
          case Some(User(name, _)) => Redirect(admin.routes.Posts.index).withSession(Security.username -> name)
        })
    }
  }

  import play.api.data.Form
  import play.api.data.Forms._
  import concurrent.duration._

  val loginForm = Form(
    tuple(
      "email" -> nonEmptyText,
      "password" -> text) )
}