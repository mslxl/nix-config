{myutils, pkgs, ...}:
{
  imports = myutils.scanPaths ./.;

  home.packages = with pkgs; [
    vivaldi
    typora
  ];
}
