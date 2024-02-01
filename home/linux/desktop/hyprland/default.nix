{myutils, pkgs, ...}:
{
  imports = myutils.scanPaths ./.;
}
