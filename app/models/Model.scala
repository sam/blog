package models

import concurrent.Future
import org.joda.time.DateTime
import org.joda.time.format.ISODateTimeFormat
import com.ning.http.util.DateUtil

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

  implicit object DateFormat extends JsonFormat[DateTime] {
    val format = ISODateTimeFormat.dateTime
    override def read(json:JsValue):DateTime = try {
      DateTime.parse(json.convertTo[String], format)
    } catch {
      new DateTime(DateUtil.parseDate(json.convertTo[String]))
    }
    override def write(date:DateTime) = format.print(date).toJson
  }
}