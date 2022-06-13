#!/usr/bin/env amm

import os._

def listAll(path: Path): Seq[Path] = {
  if (isDir(path)) {
    os.list(path).map(listAll).flatten
  } else {
    Seq(path)
  }
}

def queryMime(file: Path): String = {
  proc("xdg-mime", "query", "filetype", file)
    .call(stderr = Inherit)
    .out
    .string()
    .trim()
}

def clearDialog() {
  proc("dialog", "--clear").call(
    stdin = Inherit,
    stdout = Inherit
  )
}

def readDesktopName(path: Path): Option[String] = {
  read(path).linesIterator
    .find(_.toLowerCase.startsWith("name="))
    .map(_.substring("name=".length))
}

def radioList(title: String, item: List[Tuple2[String, String]]): String = {
  val list = item.flatMap({ case (tag, name) => Seq(name, tag, "OFF") })
  val tmp = os.temp()
  val args =
    (List[Any]("dialog", "--stderr", "--radiolist", title, 0, 0, 0)
      .concat(list))
      .map(s => Shellable(Seq(s.toString())))
  proc(args: _*)
    .call(
      stdin = Inherit,
      stdout = Inherit,
      stderr = tmp
    )
  clearDialog()
  read(tmp).trim()
}

def listDesktopFiles(): List[Path] = {
  List(
    root / "usr" / "share" / "applications",
    home / ".local" / "share" / "applications"
  ).flatMap(listAll).filter(_.ext == "desktop")
}

def setMimeList(key: String, value: String) = {
  val line = s"${key}=${value}"
  val file = home / ".config" / "mimeapps.list"
  val content = read(file).linesIterator.toList
  val idx = content.indexWhere(_.toLowerCase().startsWith(s"${key}="))
  val result =
    if (idx >= 0)
      content.patch(idx, Seq(line), 1)
    else
      content.patch(content.size, Seq(line), 0)

  write.over(file, result.mkString("\n"))
}

@main
def main(file: Path): Unit = {
  assert(exists(file))
  val mime = queryMime(file)
  println("Reading desktop files...")
  val apps =
    listDesktopFiles().map(f =>
      (readDesktopName(f).getOrElse("NoName"), f.baseName)
    )

  val select =
    radioList(
      s"Select xdg-application for ${mime}",
      apps
    )
  println(s"Use ${select}.desktop to open ${mime} filetype")
  setMimeList(mime, select + ".desktop")
}
