package models

import sprouch.{ViewQueryFlag, JsonProtocol}
import concurrent.Await
import concurrent.duration._

case class User(email:String, password:String)

object User extends Model {

  import JsonProtocol._

  implicit val userFormat = jsonFormat2(User.apply)

  def authenticate(email:String, password:String) = {
    val user = for(user <- withDb(_.getDoc[User](email)))
    yield if(user.data.password == password) Some(user.data) else None
    Await.result(user, 10 seconds).asInstanceOf[Option[User]]
  }
}