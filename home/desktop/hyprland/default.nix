{ config, pkgs, ... }:

{
  imports = [
    ../../programs/ime
    ../../programs/foot.nix
    ../../programs/wofi
    ../../programs/dunst
    ../../programs/hyprpaper.nix
    ../../programs/waybar
    ../../programs/kdeconnect.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    systemdIntegration = true;
    xwayland.enable = true;

    # settings = {};
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  services.mpd.enable = true;

  home.packages = with pkgs; [
    light
    wl-clipboard
    pamixer
    xorg.xprop
    xorg.xrdb
  ];
}
