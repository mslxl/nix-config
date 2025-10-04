{
  mylib,
  config,
  ...
}: {
  imports = mylib.scanPaths ./.;
}
