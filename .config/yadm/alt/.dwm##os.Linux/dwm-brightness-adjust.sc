#!/usr/bin/env amm
import os._

def getMax(gpu: Path): Int = read(gpu / "max_brightness").trim().toInt

def getMin() = 0

def getCur(gpu: Path): Int = read(gpu / "brightness").trim().toInt

def requestPermission(gpu: Path): Unit = {
  if (!(gpu / "brightness").toIO.canWrite) {
    proc(
      "st",
      "sudo",
      "chmod",
      "a+rw",
      (gpu / "brightness").toIO.getAbsolutePath
    ).call()
  }
}

def adjust(gpu: Path, opter: (Int, Int) => Int) = {
  requestPermission(gpu)
  write.over(gpu / "brightness", opter(getCur(gpu), 10).toString)
  proc(
    "notify-send",
    s"${gpu.baseName.capitalize} brightness changed",
    s"Current: ${getCur(gpu)}/${getMax(gpu)}",
    "--icon=dialog-information"
  ).call()
}

@main
def main(action: String): Unit = {
  val gpu = root / "sys" / "class" / "backlight"

  val opter: (Int, Int) => Int = action match {
    case "+" => (a, b) => a + b
    case "-" => (a, b) => a - b
  }

  list(gpu).foreach({ g =>
    adjust(g, opter)
  })

}
