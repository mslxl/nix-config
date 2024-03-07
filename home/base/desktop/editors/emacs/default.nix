{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.emacs.package = lib.mkForce pkgs.emacs;
}
