{
  wallpaper,
  ...
}:
let desktop_base = {
      nixos-modules = [
        ../modules/base.nix
        ../modules/nixos/desktop.nix
      ];
      home-module.imports = [
        ../home/linux/desktop.nix
      ];
};
in {
  xiaoxinpro16-2021 = let
    hyprland = {
      enable = true;
      monitors = [",2560x1600,auto,1"];
      extraConfig = '''';
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
            # sddm.bg = "${wallpaper}/nix-wallpaper-dracula.png";
          };

        }
      ]
      ++ desktop_base.nixos-modules;
    home-module.imports = [
      {
        modules.desktop = {
          background = {
            source = wallpaper + /explorer_green_day.jpg;
            variant = "dark";
          };
          hyprland = {
            inherit (hyprland) enable monitors extraConfig;
            waybar = {
              enable = true;
            };
          };
        };
      }
    ]
    ++ desktop_base.home-module.imports;
  };
}
