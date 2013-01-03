package helpers

import org.pegdown._

object Markdown {
  def markdownToHtml(input:String):String = {
    new PegDownProcessor(Extensions.FENCED_CODE_BLOCKS + Extensions.WIKILINKS).markdownToHtml(input)
  }

  def markdownToHtml[T](transform:String => T)(input:String):T = {
    transform(markdownToHtml(input))
  }
}