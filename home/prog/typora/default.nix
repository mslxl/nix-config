{ config, pkgs, ... }:
let 
    typora = pkgs.callPackage ./derv.nix {};
in {
  home.packages = [
    typora
  ];
}