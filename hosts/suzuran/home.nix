{
  lib,
  system,
  pkgs,
  pkgs-stable,
  wallpapers,
  ...
}: {
  modules = {
    aria = {
      enable = false;
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
    wakatime.enable = true;

    desktop = {
      background = {
        source = "${wallpapers}/nix-wallpaper-dracula.jpg";
        # source = pkgs.fetchurl {
        #   # https://www.reddit.com/r/NixOS/comments/166r8n7/anime_nix_wallpaper_i_created/#lightbox
        #   url = "https://i.redd.it/0f6oxa9y9jlb1.png";
        #   hash = "sha256-2V9CNXJn7fg4aSfDE6frXZtZ3bd1HnatqQP41+qJ9dw=";
        # };
        variant = "light";
      };
      hyprland = {
        enable = true;
        monitors = [
          "HDMI-A-1,1920x1080,2048x100,1"
          "eDP-1,2560x1600,0x0,1.5"
          # "HDMI-A-1,1920x1080,64x1280,1"
        ];
        extraConfig = ''
          debug:disable_scale_checks = true
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
          output eDP-1 scale 1.5
        '';
      };
    };

    music = {
      enable = false;
      ncmpcpp.enable = true;
      ario.enable = false;
    };
  };
  home.packages = with pkgs-stable;
    [
      # android-studio
    ]
    ++ (with pkgs-stable.jetbrains; [
      # pycharm-professional
      idea-ultimate
      pycharm-professional
      goland
      rider
      datagrip
    ])
    ++ (with pkgs; [
      wine
      winetricks

      zathura
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
