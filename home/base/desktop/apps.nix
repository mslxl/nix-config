{
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # obsidian
    pkgs-stable.logseq
    anki
    ffmpeg-full
    calibre
    qrcp
  ];
}
