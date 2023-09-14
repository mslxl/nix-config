{ config, pkgs, ... }:

{
  imports = [
    ../foot.nix
  ];
  programs.waybar = {
    enable = true;
  };
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/config".source = ./config;
  home.packages = with pkgs; [
    pavucontrol
    wlogout
  ];
}
