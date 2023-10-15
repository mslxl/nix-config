{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    theme = ./style.rasi;
  };
}
