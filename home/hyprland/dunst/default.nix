{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libnotify
  ];
  xdg.configFile.".config/dunst/images" = {
    source = ./images;
    recursive = true;
    executable = false;
  };
  services.dunst = {
    enable = true;
    configFile = ./dunstrc;
    settings.global.icon_path = "~/.config/dunst/images";
  };
}
