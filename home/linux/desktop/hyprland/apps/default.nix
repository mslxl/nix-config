{
  lib,
  myutils,
  config,
  ...
} @ args:
lib.mkMerge (
  map
  (p: import p args)
  [
    ./dunst.nix
    # ./foot.nix
    ./ghostty.nix
    ./swaylock.nix
  ]
)
