{
  lib,
  myutils,
  ...
}@ args: lib.mkMerge (
  map
    (p: import p args)
    [
      ./dunst.nix
      ./foot.nix
      ./swaylock.nix
    ])
