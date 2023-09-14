{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go
  ];
  programs.go.goPath = ".local/go";
}
