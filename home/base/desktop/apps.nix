{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    categories = ["Office"];
    terminal = false;
    exec = "obsidian --enable-features=UseOzonePlatform --enable-wayland-ime %u";
    comment = "Knowledge base";
    icon = "obsidian";
    mimeType = ["x-scheme-handler/obsidian"];
    type = "Application";
  };
  home.packages = with pkgs; [
    obsidian
    telegram-desktop
    anki
    ffmpeg-full
    calibre
    qrcp
  ];
}
