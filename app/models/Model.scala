package models

import concurrent.Future

trait Model {
  import play.api.libs.concurrent.Akka
  import sprouch._

  import play.api.Play._

  val actorSystem = Akka.system
  implicit val dispatcher = (actorSystem.dispatcher)

  val config = configuration.getConfig("couchdb").map { couchdb =>
    Config(actorSystem,
      couchdb.getString("host").getOrElse("localhost"),
      couchdb.getInt("port").getOrElse(5984),
      couchdb.getString("username").map(username => Some(username -> couchdb.getString("password").getOrElse(""))).getOrElse(None),
      couchdb.getBoolean("https").getOrElse(false))
  }.getOrElse(Config(actorSystem))

  val couch = Couch(config)

  val db = couch.getDb(configuration.getString("couchdb.database").getOrElse("blog"))

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