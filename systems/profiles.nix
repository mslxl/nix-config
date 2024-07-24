{inputs, ...}: let
  server_base = {
    nixos-modules = [
      inputs.nur.nixosModules.nur
      ../secrets/nixos-system.nix
      ../modules/base.nix
      ../modules/nixos/base
    ];
    home-module.imports = [
      ../home/linux/server.nix
    ];
  };
  desktop_base = {
    nixos-modules = [
      inputs.nur.nixosModules.nur
      ../secrets/nixos-system.nix
      ../modules/base.nix
      ../modules/nixos/desktop
      ../modules/nixos/base
    ];
    home-module.imports = [
      ../home/linux/desktop.nix
    ];
  };
in {
  suzuran = {
    nixos-modules =
      [
        ../hosts/suzuran
      ]
      ++ desktop_base.nixos-modules;
    home-module.imports =
      [
        ../hosts/suzuran/home.nix
      ]
      ++ desktop_base.home-module.imports;
  };
  nixos-wsl = {
    nixos-modules =
      [
        inputs.nixos-wsl.nixosModules.wsl
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
