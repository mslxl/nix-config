{
  lib,
  myutils,
  ...
}@ args: lib.mkMerge (
  map
    (p: import p args)
    (myutils.scanPaths ./.))
