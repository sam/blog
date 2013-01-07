package helpers

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

object Html {

  val dateFormat = DateTimeFormat.forPattern("yyyy-MM-dd")

  def formatDate(date:DateTime) = dateFormat.print(date)
}