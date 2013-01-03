package models

import concurrent.Future
import spray.json.{JsValue, JsonFormat}

trait Model {
  import play.api.libs.concurrent.Akka
  import sprouch._

  import play.api.Play.current

  val actorSystem = Akka.system
  implicit val dispatcher = (actorSystem.dispatcher)

  val host = "ssmoot.cloudant.com"
  val port = 5984
  val userPass = Some("" -> "")
  val https = false

  val config = Config(actorSystem, host, port, userPass, https)
  val couch = Couch(config)

  val db = couch.getDb("blog")

  def withDb[T](view:Database => Future[T]) = {
    db.flatMap(view)
  }

  import sprouch.JsonProtocol._
  import spray.json._

  implicit object DateFormat extends JsonFormat[java.util.Date] {
    val format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    override def read(json:JsValue): java.util.Date = format.parse(json.convertTo[String])
    override def write(date:java.util.Date) = format.format(date).toJson
  }
}