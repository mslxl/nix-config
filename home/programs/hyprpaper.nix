{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
  ];

  home.file.".config/hypr/wallpaper" = {
    source = ../../wallpaper;
    recursive = true;
    executable = false;
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpaper/nix-wallpaper-anime.png
    wallpaper = eDP-1,~/.config/hypr/wallpaper/nix-wallpaper-anime.png
  '';
}
