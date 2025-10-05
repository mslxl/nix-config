{
  mylib,
  catppuccin,
  ...
}: {
  imports =
    mylib.scanPaths ./.;
}
