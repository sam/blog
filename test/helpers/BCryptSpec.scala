package test.helpers

import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._

/**
 * Add your spec here.
 * You can mock out a whole application including requests, plugins etc.
 * For more information, consult the wiki.
 */
class BCryptSpec extends Specification {

  "BCrypt" should {
    "implicitly convert a String to a Password" in {
      import helpers.BCrypt._
      "bob".bcrypt must beAnInstanceOf[Password]
    }
  }
}