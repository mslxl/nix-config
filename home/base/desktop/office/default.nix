{ config, pkgs, ... }:

{
  home.packages = with pkgs;[
    wpsoffice-cn
    libreoffice-fresh
  ];
  programs.thunderbird = {
    enable = true;
    profiles.nix = {
      isDefault = true;
    };
  };
}
