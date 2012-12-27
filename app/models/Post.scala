package models

import java.util.Date

case class Post(
                 title:String,
                 body:String,
                 slug: String,
                 publishedAt: Date,
                 categories: Seq[String]) {

  }

object Post {
  def recent = {
    Seq(
      Post(title = "Test", body = "This is just a test.", slug = "test", publishedAt = new Date(), categories = Seq()),
      Post(title = "Test2", body = "Another test.", slug = "test-2", publishedAt = new Date(), categories = Seq())
    )
  }

  def archive = recent
}