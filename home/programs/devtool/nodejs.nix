{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    yarn
    nodejs
    nodePackages.pnpm
  ];
}
