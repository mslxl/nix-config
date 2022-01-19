#!/bin/env amm
@main
def main(src: os.Path): Unit = {
  src.ext match {
    case "cpp" => {
      os.proc(
        "g++",
        "-std=c++11",
        "-g",
        "-Wall",
        "-Werror",
        src,
        "-o",
        "/tmp/a.out"
      ).call(
        stdin = os.Inherit,
        stdout = os.Inherit
      )
      println("Progrom start")
      os.proc("/tmp/a.out")
        .call(
          stdin = os.Inherit,
          stdout = os.Inherit
        )
    }
    case "py" => {
      os.proc("python", src)
        .call(
          stdin = os.Inherit,
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
          stdin = os.Inherit,
          stdout = os.Inherit
        )
    }
  }
}
