{ config, pkgs, ... }:

{
  home.packages = with pkgs;[
    wpsoffice-cn
  ];
  programs.thunderbird = {
    enable = true;
    profiles.nix = {
      isDefault = true;
    };
  };
}
