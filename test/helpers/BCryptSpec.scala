package test.helpers

import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._
import helpers.BCrypt._

class BCryptSpec extends Specification {

  "BCrypt" should {
    "implicitly convert a String to a Password" in {
      "bob".bcrypt must beAnInstanceOf[Password]
    }
  }
}