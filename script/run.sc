#!/bin/env amm
import scala.io._
def exec(src: os.Path, stdin: os.ProcessInput) {
  val defaultStdin = stdin;
  

  src.ext match {
    case "cpp" => {
      os.proc(
        "g++",
        "-std=c++11",
        "-g",
        "-Wall",
        // "-Werror",
        "-fsanitize=address,undefined",
        "-DLo",
        src,
        "-o",
        "/tmp/a.out"
      ).call(
        stdin = os.Inherit,
        stdout = os.Inherit
      )
      os.proc("/tmp/a.out")
        .call(
          stdin = defaultStdin,
          stdout = os.Inherit
        )
    }
    case "py" => {
      os.proc("python", src)
        .call(
          stdin = defaultStdin,
          stdout = os.Inherit
        )
    }
    case "rs" => {
      os.proc("rustc", src, "-o", "/tmp/a.out")
        .call(
          stdin = os.Inherit,
          stdout = os.Inherit
        )
      os.proc("/tmp/a.out")
        .call(
          stdin = defaultStdin,
          stdout = os.Inherit
        )
    }
  }
}

@main
def main(src: os.Path, repeat: Boolean = false, inputFile:os.Path = null): Unit = {

  val defaultStdin: os.ProcessInput = if (!repeat && inputFile == null) {
    os.Inherit
  } else if(inputFile == null){
    val tmpFile = os.temp()
    os.proc("vim", tmpFile)
      .call(stdin = os.Inherit, stdout = os.Inherit, stderr = os.Inherit)
    os.read(tmpFile)
  }else{
    os.read(inputFile)
  }
  do {
    if (repeat) {
      println("*" * 20)
    }
    try {
      exec(src, defaultStdin)
    } catch {
      case e: Throwable => {
        System.err.println(e.getMessage())
      }
    }
    if (repeat) {
      println("*" * 20)
      println("Type [Enter] to run it again")
      StdIn.readLine()
    }
  } while (repeat)
}
