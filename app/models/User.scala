package models

import sprouch._

import helpers.BCrypt._
import sprouch.ViewQueryFlag.{inclusive_end, include_docs}
import sprouch.MapReduce
import helpers.BCrypt.Password
import scala.Some

case class User(email:String, password:Password)

object User extends Model {

  import JsonProtocol._

  implicit val userFormat = jsonFormat2(User.apply)

  def authenticate(email:String, password:String) = {
    getByEmail(email).map(_.filter(_.password == password))
  }

  def getByEmail(email:String) = {
    withDb(_.queryView[String, Null](
      "users",
      "by_email",
      flags = Set[ViewQueryFlag](include_docs, inclusive_end),
      key = Some(email)
    ).map(_.docs[User].headOption))
  }

  object Views {
    import sprouch.{ Views => SprouchView }
    val byEmail = MapReduce(
      map = """
               function(user) {
                 if(user.email)
                   emit(user.email, null);
               }
            """,
      reduce = None
    )

    val doc = new NewDocument("users", SprouchView(Map(
      "by_email" -> byEmail
    )))

    def create = {
      User.withDb(_.createViews(doc))
    }
  }
}