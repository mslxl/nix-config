{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    vivaldi
  ]);
}
