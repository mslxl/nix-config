#!/usr/bin/env amm
import ammonite.ops._
import ammonite.ops.ImplicitWd._
import javax.swing._, java.awt.event._

val gpu = root / 'sys / 'class / 'backlight / 'amdgpu_bl0

def getMax(): Int = (read ! gpu / 'max_brightness).trim().toInt
def getMin() = 0
def getCur(): Int = (read ! gpu / 'brightness).trim().toInt
def requestPermission(): Unit = {
  if (!(gpu / 'brightness).toIO.canWrite) {
    %(List("st", "sudo", "chmod", "a+rw", (gpu / 'brightness).toIO.getAbsolutePath()))
  }
}

@main
def main(action: String): Unit = {
  requestPermission
  val opter:(Int,Int)=>Int = action match{
    case "+" => (a,b) => a+b
    case "-" => (a,b) => a-b
  }
  write.over(gpu / 'brightness, opter(getCur, 10).toString)
  %(List("notify-send", "Brightness Changed", s"Current: ${getCur}/${getMax}", "--icon=dialog-information"))
}
