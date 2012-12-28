package controllers

import play.api.mvc._
import models._

object Posts extends Controller {

  def index = Action {
    Ok(views.html.Posts.index(Post.recent, Post.archive, Category.titles))
  }

  def show(slug: String) = TODO

  def create = TODO

  def delete(id: String) = TODO

}