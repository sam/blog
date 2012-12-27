package models

import com.typesafe.config.ConfigFactory

case class Category(title:String)

object Category {

  import sprouch._
  import sprouch.JsonProtocol._
  import akka.actor.ActorSystem

//  implicit val categoryFormat = jsonFormat3(Category)

//  val myActor = Akka.system.actorOf(Props[MyActor], name = "myactor")

  val couchdbProperties = ConfigFactory.load("couchdb.properties")
  val couchdbActor = ActorSystem("couchdb")
//
//
//
//  val config = Config(
//    ActorSystem("couchdb"),
//    hostName = couchdbProperties.getConfig("couchdb.host").toString,
//    port = couchdbProperties.getConfig("couchdb.port").toString.toInt,
//    userPass = Some(couchdbProperties.getConfig("couchdb.username").toString -> couchdbProperties.getConfig("couchdb.password").toString),
//    https = if(couchdbProperties.getConfig("couchdb.protocol").toString == "https") true else false
//  )
//
//  val couch = Couch(config)

  def titles = Seq("One", "Two", "Three")

//  def titles
//  @cache.get("categories") do
//  COUCH.view("posts/categories", group: true)["rows"].map { |row| row["key"] }
//  end
//  end
}