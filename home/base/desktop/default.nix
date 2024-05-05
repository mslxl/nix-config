{
  myutils,
  config,
  ...
}: {
  imports = myutils.scanPaths ./.;

  config = {
    home.file.".wallpaper".source = config.modules.desktop.background.source;
  };
}
