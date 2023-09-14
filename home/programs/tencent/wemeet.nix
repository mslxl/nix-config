{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.nur.repos.linyinfeng.wemeet
  ];
}
