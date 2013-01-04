package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached
import forms._

object Admin extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = TODO
}