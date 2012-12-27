import com.typesafe.config.ConfigFactory
import play.api._

object Global extends GlobalSettings {
  val couchdbProperties = ConfigFactory.load("couchdb.properties")
}