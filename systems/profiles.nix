{ inputs, ... }:
let
  server_base = {
    nixos-modules = [
      inputs.nur.modules.nixos.default
      inputs.catppuccin.nixosModules.catppuccin
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/base.nix
    ];
    home-module.imports = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.catppuccin.homeModules.catppuccin
      ../home/linux/server.nix
    ];
  };
  desktop_base = {
    nixos-modules = [
      inputs.nur.modules.nixos.default
      inputs.catppuccin.nixosModules.catppuccin
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/desktop.nix
    ];
    home-module.imports = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.niri.homeModules.niri
      inputs.catppuccin.homeModules.catppuccin
      ../home/linux/desktop.nix
    ];
  };
in
{
  suzuran = {
    nixos-modules = [
      ../hosts/suzuran
    ]
    ++ desktop_base.nixos-modules;
    home-module.imports = [
      ../hosts/suzuran/home.nix
    ]
    ++ desktop_base.home-module.imports;
  };
  nixos-wsl = {
    nixos-modules = [
      inputs.nixos-wsl.nixosModules.wsl
      ../hosts/nixos-wsl
    ]
    ++ server_base.nixos-modules;
    home-module.imports = [
      ../hosts/nixos-wsl/home.nix
    ]
    ++ server_base.home-module.imports;
  };
}
