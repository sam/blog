package models

import play.api.libs.ws.{Response, WS}
import play.api.libs.concurrent.Akka
import akka.util.Timeout
import concurrent.Await

case class Category(title:String)

object Couch {
  def query[T](url:String, response:Response => T):T = {
    import play.api.Play.current
    val akkaSystem = Akka.system
    import akkaSystem.dispatcher

    response(Await.result(WS.url(url).get, Timeout(1000).duration))
  }
}

object Category {
  def titles = {
    Couch.query[Seq[String]]("http://127.0.0.1:5984/blog/_design/posts/_view/categories?group=true", {
      response => (response.json \ "rows" \\ "key").map(_.as[String])
    })
  }
}