{ config, pkgs, ... }:

{
  home.packages = with pkgs;[
    wpsoffice
  ];
  programs.thunderbird = {
    enable = true;
    profiles.nix = {
      isDefault = true;
    };
  };
}
