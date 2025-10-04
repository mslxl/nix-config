{
  mylib,
  pkgs,
  ...
}: {
  imports = mylib.scanPaths ./.;
}
