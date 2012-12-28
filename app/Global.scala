import play.api._

object Global extends GlobalSettings {

  lazy val couch = {
    import sprouch._
    import play.api.Play.current
    import play.api.libs.concurrent.Akka

    val host = "ssmoot.cloudant.com"
    val port = 5984
    val userPass = Some("" -> "")
    val https = false

    val config = Config(Akka.system, host, port, userPass, https)
    Couch(config)
  }
}