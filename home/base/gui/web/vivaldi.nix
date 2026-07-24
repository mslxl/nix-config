{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: {
  home.packages = (lib.optional pkgs.stdenv.isLinux (with pkgs; [
    vivaldi
  ]));
}