{ config, lib, pkgs, ... }:

{
  home.username = "mslxl";
  home.homeDirectory = "/home/mslxl";

  home.packages = with pkgs; [
    vivaldi
    typora
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
