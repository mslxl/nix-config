{ config, pkgs, ... }:

{
  programs.feh.enable = true;
  programs.mpv.enable = true;
  home.packages = with pkgs;[
    gimp-with-plugins
    grim
    slurp
  ];
  home.file.".local/bin/screenshot" =  {
    source = ./screenshot.sh;
    executable = true;
  };
}
