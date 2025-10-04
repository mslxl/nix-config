{
  mylib,
  config,
  ...
}: {
  imports = mylib.scanPaths ./.;

  config = {
    home.file.".wallpaper".source = config.modules.desktop.background.source;
  };
}
