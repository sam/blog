package models

import sprouch.{SprouchException, ViewQueryFlag, JsonProtocol}
import concurrent.{Future, Await}
import concurrent.duration._

import helpers.BCrypt._
import play.libs.Akka

case class User(email:String, password:Password)

object User extends Model {

  import JsonProtocol._

  implicit val userFormat = jsonFormat2(User.apply)

  def authenticate(email:String, password:String) = {

    val future = db.flatMap { db =>
      db.getDoc[User](email).map { doc =>
        Some(doc.data).filter(_.password == password)
      }.recover {
        case e:SprouchException if e.error.status == 404 => None
      }
    }
    Await.result(future, 10 seconds)

  }
}