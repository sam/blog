package controllers

import play.api.mvc._
import models._
import concurrent.{Future, Await}

object Application extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def login = Action {
    Ok(views.html.Application.login(loginForm))
  }

  def submitLogin = Action { implicit request =>
    Async {
      Future(
        loginForm.bindFromRequest.fold(
          errors => BadRequest(views.html.Application.login(errors)),
          value => Redirect(admin.routes.Posts.index).withSession(Security.username -> value._1)
        )
      )
    }
  }

  import play.api.data.Form
  import play.api.data.Forms._
  import concurrent.duration._

  val loginForm = Form(
    tuple(
      "email" -> nonEmptyText,
      "password" -> text
    ) verifying("Invalid email or password.", fields => fields match {
      case (e, p) => Await.result(User.authenticate(e,p).map(_.isDefined), 5 seconds)
    })
  )
}