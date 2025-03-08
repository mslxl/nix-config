{
  pkgs,
  wallpapers,
  ...
}: {
  modules.desktop = {
    hyprland = {
      enable = false;
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
      enable = true;
    };
  };

  # services.v2raya.enable = true;
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    package = pkgs.clash-verge-rev;
  };

  nix.settings = {
    max-jobs = 12; # leave 4 CPU for other work, which would make computer available when rebuild
    cores = 12;
  };
}
