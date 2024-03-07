{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    obsidian
    telegram-desktop
    anki
    ffmpeg-full
    calibre
    bitwarden
  ];
}
