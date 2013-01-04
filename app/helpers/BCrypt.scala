package helpers

import org.mindrot.jbcrypt.{BCrypt => B}

object BCrypt {
  implicit class Password(val hash:String) {

    def toPassword = new Password(hash)

    def bcrypt = new Password(B.hashpw(hash, B.gensalt))

    def ==(plainTextCandidate:String) = B.checkpw(plainTextCandidate, hash)

    override def toString = hash
  }
}