{
  lib,
  system,
  pkgs,
  niri,
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
      exec = {
        once = [
          "clash-verge"
        ];
      };
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
      niri = {
        settings = let
          inherit
            (niri.lib.kdl)
            node
            plain
            leaf
            flag
            ;
        in [
          # running `niri msg outputs` to find outputs
          (node "output" "eDP-1" [
            # Uncomment this line to disable this output.
            # (flag "off")

            # Scale is a floating-point number, but at the moment only integer values work.
            (leaf "scale" 1.5)

            # Transform allows to rotate the output counter-clockwise, valid values are:
            # normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
            (leaf "transform" "normal")

            # Resolution and, optionally, refresh rate of the output.
            # The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
            # If the refresh rate is omitted, niri will pick the highest refresh rate
            # for the resolution.
            # If the mode is omitted altogether or is invalid, niri will pick one automatically.
            # Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
            (leaf "mode" "2560x1600@120")

            # Position of the output in the global coordinate space.
            # This affects directional monitor actions like "focus-monitor-left", and cursor movement.
            # The cursor can only move between directly adjacent outputs.
            # Output scale has to be taken into account for positioning:
            # outputs are sized in logical, or scaled, pixels.
            # For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
            # so to put another output directly adjacent to it on the right, set its x to 1920.
            # It the position is unset or results in an overlap, the output is instead placed
            # automatically.
            (leaf "position" {
              x = 0;
              y = 0;
            })
          ])
          # (node "output" "HDMI-A-1" [
          #   (leaf "scale" 1.5)
          #   (leaf "transform" "normal")
          #   (leaf "mode" "3840x2160@60")
          #   (leaf "position" {
          #     x = 2560; # on the right of DP-2
          #     y = 0;
          #   })
          # ])
        ];
      };

      sway = {
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
  home.packages = with pkgs-stable.jetbrains;
    [
      # pycharm-professional
      idea-ultimate
      pycharm-professional
      goland
      rider
      datagrip
    ]
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
