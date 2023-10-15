{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    calibre
    calibre-web
  ];
}
