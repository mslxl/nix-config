{ config, pkgs, ... }:

{
  # Maybe use flake and direnv is a better choice?
  home.packages = with pkgs; [
    yarn
    nodejs
    nodePackages.pnpm
  ];
}
