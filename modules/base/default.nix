{
  mylib,
  catppuccin,
  ...
}: {
  imports =
    [
      catppuccin.nixosModules.catppuccin
    ]
    ++ (mylib.scanPaths ./.);
}
