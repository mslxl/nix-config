{
  pkgs,
  pkgs-stable,
  ...
}: {
  modules = {
    game = {
      minecraft.enable = true;
      steam.enable = true;
    };

    desktop = {
      background = {
        source = ../../wallpaper/pixiv-104537131.png;
        variant = "dark";
      };
      hyprland = {
        enable = false;
        monitors = [
          "eDP-1,2560x1600,0x0,1.25"
          "HDMI-A-1,1920x1080,64x1280,1"
        ];
        extraConfig = ''
          xwayland {
            force_zero_scaling = 1
          }

          # default is 96, 96 * 1.25 is 120
          exec = bash -c "echo 'Xft.dpi: 120' | xrdb -merge"
        '';
      };
      sway = {
        enable = false;
        extraConfig = ''
          output eDP-1 scale 1.3
        '';
      };
    };
  };
  home.packages = with pkgs.jetbrains;
    [
      webstorm
      rust-rover
      pycharm-professional
      mps
      idea-ultimate
      idea-community
      goland
      gateway
      datagrip
    ]
    ++ (with pkgs; [
      zathura
      geogebra6
      appimage-run
    ]);
}
