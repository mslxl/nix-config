{
  wallpaper,
  nixos-wsl,
  ...
}: let
  server_base = {
    nixos-modules = [
      ../modules/base.nix
      ../modules/nixos/base
    ];
    home-module.imports = [
      ../home/linux/server.nix
    ];
  };
  desktop_base = {
    nixos-modules = [
      ../modules/base.nix
      ../modules/nixos/desktop
      ../modules/nixos/base
    ];
    home-module.imports = [
      ../home/linux/desktop.nix
    ];
  };
in {
  xiaoxinpro16-2021 = let
    background = ../wallpaper/pixiv-104537131.png;
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
    };
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  in {
    nixos-modules =
      [
        ../hosts/xiaoxinpro16-2021
        {
          modules.desktop = {
            hyprland = {
              inherit (hyprland) enable;
            };
            sddm = {
              bg = background;
              enable = true;
            };
            sway = {
              inherit (sway) enable;
            };
            plasma = {
              inherit (plasma) enable;
            };
          };
        }
      ]
      ++ desktop_base.nixos-modules;
    home-module.imports =
      [
        ../hosts/xiaoxinpro16-2021/home.nix
        {
          modules.desktop = {
            background = {
              source = background;
              variant = "dark";
            };
            hyprland = {
              inherit (hyprland) enable monitors extraConfig;
            };
            sway = {
              inherit (sway) enable;
              extraConfig = ''
                output eDP-1 scale 1.3
              '';
            };
          };
        }
      ]
      ++ desktop_base.home-module.imports;
  };
  nixos-wsl = {
    nixos-modules =
      [
        nixos-wsl.nixosModules.wsl
        ../hosts/nixos-wsl
      ]
      ++ server_base.nixos-modules;
    home-module.imports =
      [
        ../hosts/nixos-wsl/home.nix
      ]
      ++ server_base.home-module.imports;
  };
}
