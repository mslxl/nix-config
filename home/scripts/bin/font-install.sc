#!/usr/bin/env amm
import os._

def install(file: Path): Unit = {
  copy(
    file,
    root / "usr" / "share" / "fonts",
    followLinks = true,
    replaceExisting = true,
    copyAttributes = false,
    createFolders = true,
    mergeFolders = true
  )

}

def flush(): Unit = {
  proc("mkfontscale").call()
  proc("mkfontdir").call()
  proc("fc-cache").call()
}

@main
def main(file: Path*): Unit = {
  if (!file.forall(os.exists)) {
    throw new RuntimeException("File not exists")
  }
  file.foreach(install)
  flush()
}