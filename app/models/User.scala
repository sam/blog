package models

import sprouch.{SprouchException, ViewQueryFlag, JsonProtocol}

import helpers.BCrypt._

case class User(email:String, password:Password)

object User extends Model {

  import JsonProtocol._

  implicit val userFormat = jsonFormat2(User.apply)

  def authenticate(email:String, password:String) = {
    db.flatMap { db =>
      db.getDoc[User](email).map { doc =>
        Some(doc.data).filter(_.password == password)
      }.recover {
        case e:SprouchException if e.error.status == 404 => None
      }
    }
  }
}