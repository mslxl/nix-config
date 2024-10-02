{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    logseq
    anki
    ffmpeg-full
    calibre
    qrcp
  ];
}
