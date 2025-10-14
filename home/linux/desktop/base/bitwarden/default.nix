{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-desktop
  ];
}
