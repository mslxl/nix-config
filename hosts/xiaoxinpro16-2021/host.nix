{pkgs, ...}: {
  modules.desktop = {
    hyprland = {
      enable = false;
    };
    xmonad = {
      enable = true;
      startupOnce = ''
        xrandr --output eDP --scale 0.75
        bash -c "echo 'Xft.dpi: 96' | xrdb -merge"
        fcitx5 -d &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
      '';
    };
    sddm = {
      enable = true;
      bg = ../../wallpaper/northern-night.jpg;
    };
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  };
}
