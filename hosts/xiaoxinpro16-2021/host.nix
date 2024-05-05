{pkgs, ...}: {
  modules.desktop = {
    hyprland = {
      enable = false;
    };
    xmonad = {
      enable = true;
      startupOnce = ''
        xrandr --output eDP --scale 0.8
        fcitx5 -d &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
      '';
    };
    sddm = {
      enable = true;
      bg = ../../wallpaper/pixiv-104537131.png;
    };
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  };
}
