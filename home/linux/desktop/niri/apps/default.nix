{
  lib,
  mylib,
  ...
} @ args:
lib.mkMerge (
  map
  (p: import p args)
  (mylib.scanPaths ./.)
)
