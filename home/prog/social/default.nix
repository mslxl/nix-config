{ config, pkgs, pkgs-xddxdd,  ... }:
let 
  qqnt = pkgs.callPackage ./qqnt.derv.nix {};
in {
  home.packages = with pkgs; [
    telegram-desktop
    qqnt
    pkgs-xddxdd.wine-wechat
    nur.repos.linyinfeng.wemeet 
  ];

}
