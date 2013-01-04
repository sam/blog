package helpers

import org.mindrot.jbcrypt.{BCrypt => B}

object BCrypt {
  implicit class Password(val hash:String) {

    def toPassword = new Password(hash)

    def bcrypt = new Password(B.hashpw(hash, B.gensalt))

    def ==(plainTextCandidate:String) = B.checkpw(plainTextCandidate, hash)

    override def toString = hash
  }

  import sprouch.JsonProtocol._
  import spray.json._

  implicit object PasswordFormat extends JsonFormat[Password] {
    override def read(json:JsValue) = json.convertTo[String].toPassword
    override def write(passwordHash:Password) = passwordHash.hash.toJson
  }
}