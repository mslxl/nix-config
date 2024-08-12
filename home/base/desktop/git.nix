{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    github-desktop
  ];
}
