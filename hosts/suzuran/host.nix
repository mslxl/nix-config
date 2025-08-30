{
  pkgs,
  wallpapers,
  ...
}: {
  modules.desktop = {
    wayland.enable = true;
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
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  };

  nix.settings = {
    max-jobs = 12; # leave 4 CPU for other work, which would make computer available when rebuild
    cores = 12;
  };
}
