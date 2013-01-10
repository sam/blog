package test.unit.helpers

import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._
import helpers.BCrypt._

class BCryptSpec extends Specification {

  "BCrypt" should {
    "implicitly convert a String to a Password" in {
      "bob".bcrypt must beAnInstanceOf[Password]
    }

    "return hash when toString is called" in {
      val bob = "bob".bcrypt
      bob.toString mustEqual bob.hash
    }

    "match a Password to a plain text candidate" in {
      // Here we're calling Password#==(String),
      // so simply saying:
      //   "bob".bcrypt === "bob"
      // Wouldn't work since that doesn't call
      // ==() or equal() on the LHS.
      "bob".bcrypt == "bob" mustEqual true
    }

    "be able to create a Password from a hash" in {
      val hash = "bob".bcrypt.hash
      val password = hash.toPassword

      hash must beAnInstanceOf[String]
      password must beAnInstanceOf[Password]
      password == "bob" mustEqual true
    }
  }
}
