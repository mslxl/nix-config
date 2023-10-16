{ config, pkgs, ... }:

{
  programs.feh.enable = true;

  home.packages = with pkgs;[
    gimp-with-plugins
    grim
    slurp
  ];
  xdg.configFile.".local/bin/screenshot" =  {
    source = ./screenshot.sh;
    executable = true;
  };
}
