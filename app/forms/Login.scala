package forms

import play.api.data._
import play.api.data.Forms._
import models.User

object Login {
  import play.api.data.validation.Constraints._

  val form = Form(
    tuple(
      "email" -> nonEmptyText,
      "password" -> text
    ) verifying("Invalid user name or password", fields => fields match {
      case (e, p) => User.authenticate(e,p).isDefined
    })
  )
}