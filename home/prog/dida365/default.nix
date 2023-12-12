{ config, pkgs, ... }:
let 
    dida = pkgs.callPackage ./derv.nix {};
in {
  home.packages = [
    dida
  ];
}