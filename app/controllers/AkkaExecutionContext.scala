package controllers

trait AkkaExecutionContext {
  import play.api.libs.concurrent.Akka
  import play.api.Play.current
  val akkaSystem = Akka.system
}