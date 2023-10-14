{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.goland
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    jetbrains.datagrip
  ];
}
