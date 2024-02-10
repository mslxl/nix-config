{
  wallpaper,
  ...
}:
let desktop_base = {
      nixos-modules = [
        ../modules/base.nix
        ../modules/nixos/desktop
      ];
      home-module.imports = [
        ../home/linux/desktop.nix
      ];
};
in {
  xiaoxinpro16-2021 = let
    background = wallpaper + /nix-wallpaper-dracula.png;
    hyprland = {
      enable = false;
      monitors = [",2560x1600,auto,1"];
      extraConfig = '''';
    };
    sway = {
      enable = true;
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
    home-module.imports = [
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
          };
        };
      }
    ]
    ++ desktop_base.home-module.imports;
  };
}
