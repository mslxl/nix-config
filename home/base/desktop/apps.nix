{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # obsidian
    logseq
    anki
    ffmpeg-full
    calibre
    qrcp
  ];
}
