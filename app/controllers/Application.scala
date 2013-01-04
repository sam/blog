package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached

object Application extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def login = Action {
    Ok(views.html.Application.login(loginForm))
  }

  def submitLogin = Action { implicit request =>
    loginForm.bindFromRequest.fold(
      errors => BadRequest(views.html.Application.login(errors)),
      value => Redirect(routes.Admin.index).withSession("email" -> value._1)
    )
  }

  import play.api.data.Form
  import play.api.data.Forms._

//  import play.api.data.validation.Constraints._

  val loginForm = Form(
    tuple(
      "email" -> nonEmptyText,
      "password" -> text
    ) verifying("Invalid email or password.", fields => fields match {
      case (e, p) => User.authenticate(e,p).isDefined
    })
  )
}