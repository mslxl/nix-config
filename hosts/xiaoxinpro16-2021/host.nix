{
  pkgs,
  wallpapers,
  ...
}: {
  modules.desktop = {
    hyprland = {
      enable = true;
    };
    xmonad = {
      enable = false;
      startupOnce = ''
        xrandr --output eDP --scale 0.75
        bash -c "echo 'Xft.dpi: 96' | xrdb -merge"
        fcitx5 -d &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
      '';
    };
    sddm = {
      enable = true;
      bg = "${wallpapers}/nix-wallpaper-dracula.jpg";
    };
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  };
}
