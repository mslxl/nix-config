{ config, pkgs, pkgs-xddxdd,  ... }:
let 
  apifox = pkgs.callPackage ./derv.nix {};
in {
  home.packages = with pkgs; [
    apifox
  ];

}
