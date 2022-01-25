@main
def main(): Unit = {
  println("Ammonite start successfully!")
  check_doom_emacs()
}

def check_git(): Unit = {
  println("Check git...")
  try {
    os.proc("git", "--version")
  } catch {
    case _ =>
      System.err.println("git missing. Bootstrap interrupted!")
      exit(1)
  }
}

def check_doom_emacs(): Unit = {
  check_git()
  println("Check doom emacs...")
  val dir = os.home / ".emacs.d"
  if (!os.exists(dir)) {
    os.proc(
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/hlissner/doom-emacs",
      "~/.emacs.d"
    ).call(stdin = os.Inherit, stdout = os.Inherit)
    os.proc(os.home / ".emacs.d" / "bin" / "doom", "install")
  }
}
