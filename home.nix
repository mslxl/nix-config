{ config, lib, pkgs, ... }:

{
  home.username = "mslxl";
  home.homeDirectory = "/home/mslxl";

  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs

    pfetch
  ];

  programs.git = {
    enable = true;
    userName = "Mslxl";
    userEmail = "i@mslxl.com";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}
