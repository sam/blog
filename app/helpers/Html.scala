package helpers

import java.util.Date
import java.text.SimpleDateFormat

object Html {

  val dateFormat = new SimpleDateFormat("yyyy-MM-dd")

  def formatDate(date:Date) = dateFormat.format(date)
}