{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
  };
  xdg.configFile.".config/waybar/style.css".source = ./style.css;
  xdg.configFile.".config/waybar/config".source = ./config;
  home.packages = with pkgs; [
    pavucontrol
    wlogout
  ];
}
