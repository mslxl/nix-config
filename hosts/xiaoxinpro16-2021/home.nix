{
  system,

  pkgs,
  pkgs-stable,
  sticky-bucket,
  ...
}: {
  modules = {
    game = {
      minecraft.enable = false;
      steam.enable = true;
      osu.enable = true;
    };

    desktop = {
      background = {
        source = ../../wallpaper/stargazer.jpg;
        variant = "dark";
      };
      hyprland = {
        enable = true;
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
        waybar = {
          theme = "ml4w";
          variant = "colored";
        };
      };
      sway = {
        enable = false;
        extraConfig = ''
          output eDP-1 scale 1.3
        '';
      };
    };
  };
  home.packages = with pkgs-stable;
    [
      android-studio

      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.pycharm-professional
      jetbrains.mps
      jetbrains.idea-ultimate
      jetbrains.idea-community
      jetbrains.goland
      jetbrains.gateway
      jetbrains.clion
      jetbrains.datagrip
    ]
    ++ (with pkgs; [
      wine
      winetricks

      zathura
      geogebra6
      zotero
      cpeditor
      appimage-run
      typora

      sticky-bucket.packages.${system}.default
    ]);
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
