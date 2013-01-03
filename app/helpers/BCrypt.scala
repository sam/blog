package helpers

import org.mindrot.jbcrypt.{BCrypt => B}

object BCrypt {
  implicit class Password(plainText:String) {

    def bcrypt = this // This feels a little hokey, but it lets you "bob".bcrypt and get back a Password instance.

    val hash:String = B.hashpw(plainText, B.gensalt)

    def ==(plainTextCandidate:String) = B.checkpw(plainTextCandidate, hash)
  }
}