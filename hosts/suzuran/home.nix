{
  system,
  pkgs,
  pkgs-stable,
  wallpapers,
  ...
}: {
  modules = {
    aria = {
      enable = true;
      daemon = {
        enable = true;
        max-concurrent-downloads = 32;
        max-connection-per-server = 16;
        split = 64;
        disable-ipv6 = true;
        no-netrc = true;
        bt-max-peers = 128;
        rpc-allow-origin-all = false;
      };
    };
    game.minecraft.enable = true;

    desktop = {
      background = {
        source = "${wallpapers}/twitter-1774762746007204094.jpg";
        variant = "light";
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
          theme = "ml4w-blur";
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
      zotero-beta
      cpeditor
      appimage-run
    ]);
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
