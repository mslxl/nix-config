{
  description = "Mslxl's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # do you like emacs :)
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nix-colors , ... }@inputs:
    let
      constants = import ./constants.nix;
      forEachSystem = func: (nixpkgs.lib.genAttrs constants.allSystems func);
      allSystemConfigurations = import ./systems {inherit self inputs constants;};
    in allSystemConfigurations
       // {
          formatter = forEachSystem (
            system: nixpkgs.legacyPackages.${system}.alejandra
          );
       };
}
