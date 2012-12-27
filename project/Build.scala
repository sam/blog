import sbt._
import Keys._
import play.Project._

object ApplicationBuild extends Build {

  val appName         = "blog"
  val appVersion      = "1.0-SNAPSHOT"

  val appDependencies = Seq(
    // Add your project dependencies here,
    javaCore,
    javaJdbc,
    javaEbean,
    "sprouch" % "sprouch_2.10.0-RC3" % "0.5.4"
  )

  val main = play.Project(appName, appVersion, appDependencies).settings(
    resolvers += "Sprouch Repository" at "http://kimstebel.github.com/sprouch/repository",
    resolvers += "Spray Repository" at "http://repo.spray.io"
  )

}
