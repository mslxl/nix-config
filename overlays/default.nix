# execute and import all overlay files in the current directory with the given args
args:
builtins.map
(f: (import (./. + "/${f}") args))
(builtins.filter
  (f: f != "default.nix" && f != "README.md")
  (builtins.attrNames (builtins.readDir ./.)))
