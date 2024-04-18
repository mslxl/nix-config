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
  xiaoxinpro16-2021 = {
    nixos-modules =
      [
        ../hosts/xiaoxinpro16-2021
      ]
      ++ desktop_base.nixos-modules;
    home-module.imports =
      [
        ../hosts/xiaoxinpro16-2021/home.nix
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
