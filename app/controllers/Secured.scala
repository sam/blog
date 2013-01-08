package controllers

import play.api.mvc._
import play.api.mvc.Security._
import models._

trait Secured extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def username(request: RequestHeader) = request.session.get(Security.username)

  def onUnauthorized(request: RequestHeader) = Results.Redirect(routes.Application.login)

  def withAuth(f: => String => Request[AnyContent] => Result) = {
    Security.Authenticated(username, onUnauthorized) { user =>
      Action(request => f(user)(request))
    }
  }

  def withUser(f: User => Request[AnyContent] => Result) = withAuth { username => implicit request =>
    Async {
      for(user <- User.getByEmail(username))
      yield user.map(f(_)(request)).getOrElse(onUnauthorized(request))
    }
  }
}