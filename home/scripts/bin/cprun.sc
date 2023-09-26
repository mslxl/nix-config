#!/usr/bin/env amm
import scala.io._

def withTime(tag: String = "program", code: () => Unit): Unit = {
  val startTime = System.currentTimeMillis()
  println("*" * 10 + tag + "*" * 10)
  code()
  println()
  val endTime = System.currentTimeMillis()
  val per = endTime - startTime
  println(
    s"Exec $tag consumed ${per / 1000 / 60}mins ${per / 1000 % 60}s ${per % 1000}ms"
  )
  println("*" * 10)
}

def exec(
    src: os.Path,
    stdin: os.ProcessInput,
    stdout: os.ProcessOutput = os.Inherit
) {
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
        "-DLocal",
        src,
        "-o",
        "/tmp/a.out"
      ).call(
        stdin = os.Inherit,
        stdout = os.Inherit
      )
      withTime(
        src.toString(),
        () =>
          os.proc("/tmp/a.out")
            .call(
              stdin = defaultStdin,
              stdout = stdout
            )
      )
    }
    case "py" => {
      withTime(
        src.toString(),
        () =>
          os.proc("python", src)
            .call(
              stdin = defaultStdin,
              stdout = stdout
            )
      )
    }
    case "rs" => {
      os.proc("rustc", src, "-o", "/tmp/a.out")
        .call(
          stdin = os.Inherit,
          stdout = os.Inherit
        )
      withTime(
        src.toString(),
        () =>
          os.proc("/tmp/a.out")
            .call(
              stdin = defaultStdin,
              stdout = stdout
            )
      )
    }
  }
}

@main
def main(
    file: os.Path = null,
    repeat: Boolean = false,
    in: os.Path = null,
    cmpCode: os.Path = null,
    cmpOut: os.Path = null
): Unit = {
  val compareOutput = (cmpOut != null) || (cmpCode != null)

  val src = if (file == null) {
    print("File ext: ")
    val fileType = StdIn.readLine().trim()
    val tmpFile = os.temp(suffix = s".$fileType")
    os.proc("vim", tmpFile)
      .call(stdin = os.Inherit, stdout = os.Inherit, stderr = os.Inherit)
    println(s"Start compiling $tmpFile")
    tmpFile
  } else {
    file
  }

  val defaultStdin: os.ProcessInput =
    if ((!repeat && in == null) && !compareOutput) {
      os.Inherit
    } else if (in == null) {
      val tmpFile = os.temp()
      os.proc("vim", tmpFile)
        .call(stdin = os.Inherit, stdout = os.Inherit, stderr = os.Inherit)
      os.read(tmpFile)
    } else {
      os.read(in)
    }

  do {
    try {
      if (!compareOutput) {
        exec(src, defaultStdin)
      } else if (cmpOut != null) {
        val output = os.temp()
        exec(src, defaultStdin, output)
        compare(output, cmpOut)
      } else if (cmpCode != null) {
        val output = os.temp(prefix = src.baseName + ".", suffix = ".output")
        val template =
          os.temp(prefix = cmpCode.baseName + ".", suffix = ".output")
        exec(src, defaultStdin, output)
        exec(cmpCode, defaultStdin, template)
        compare(output, template)
      }
    } catch {
      case e: Throwable => {
        System.err.println(e.getMessage())
      }
    }

    if (repeat) {
      StdIn.readLine()
    }
  } while (repeat)
}

def compare(f1:os.Path, f2:os.Path):Unit = {
        val code = os.proc("diff", "-u", f1, f2)
          .call(stdin = os.Inherit, stdout = os.Inherit, stderr = os.Inherit).exitCode
  if(code == 0){
    println("Output is identical!")
  }
}
