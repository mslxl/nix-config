{
  myutils,
  pkgs,
  ...
}: {
  imports = myutils.scanPaths ./.;
  environment.systemPackages = with pkgs; [
    bottom
    mpv
  ];
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
}
