{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    dwm-status
  ];
  home.file.".dwm/dwm-status.toml".source = ./dwm-status.toml;
}
