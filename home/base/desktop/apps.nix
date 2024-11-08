{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    obsidian
    anki
    ffmpeg-full
    calibre
    qrcp
  ];
}
