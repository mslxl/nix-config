{
  myutils,
  pkgs,
  ...
}: {
  imports = myutils.scanPaths ./.;
  environment.systemPackages = with pkgs; [
    bottom
  ];
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
}
