#!/bin/env amm
@main
def main(dir: os.Path = os.pwd): Unit = {
  if (hasFile(dir) && !hasSubFolder(dir)) {
    println(s"Pack $dir")
    pack(dir)(dir)
  } else {
    println(s"Pack folder in $dir repectively")
    os.list(dir)
      .filter(os.isDir)
      .foreach(pack(dir) _)
  }
}

def hasSubFolder(dir: os.Path): Boolean = os
  .list(dir)
  .find(os.isDir)
  .map(_ => true)
  .getOrElse(false)

def hasFile(dir: os.Path): Boolean = os
  .list(dir)
  .find(os.isFile)
  .map(_ => true)
  .getOrElse(false)

def pack(storePath: os.Path)(dir: os.Path): Unit = {
  println("*" * 20)
  println(s"Pack ${dir} in ${storePath}")

  val files = os
    .list(dir)
    .filter(path =>
      os.isFile(path) && Array("jpg", "png", "jpeg").contains(path.ext)
    )
  val target = storePath / (dir.baseName + ".zip")
  execPack(files, target)

  println("*" * 20)
}

def execPack(pic: Seq[os.Path], target: os.Path): Unit = {
  if (pic.isEmpty) {
    println("Pictures file is empty, skip it")
    return
  }
  val cmd = (Seq("zip", "-j", "-9", target) ++ pic)
    .map(s => os.Shellable(Seq(s.toString)))
  val cmdLine = cmd
    .map(_.value)
    .flatten
    .reduce(_ + " " + _)
  println(s"""Exec "$cmdLine"""")

  val ps = os.proc(cmd: _*).call()
  if (ps.exitCode != 0) {
    System.exit(ps.exitCode)
  }
}