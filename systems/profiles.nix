{inputs, ...}: let
  server_base = {
    nixos-modules = [
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/base
    ];
    home-module.imports = [
      inputs.sops-nix.homeManagerModules.sops
      ../home/linux/server.nix
    ];
  };
  desktop_base = {
    nixos-modules = [
      inputs.nur.modules.nixos.default
      inputs.catppuccin.nixosModules.catppuccin
      ../modules/nixos/base
      ../modules/nixos/desktop.nix
    ];
    home-module.imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      inputs.niri.homeModules.niri
      inputs.catppuccin.homeModules.catppuccin
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
