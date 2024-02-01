{
  description = "Mslxl's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      constants = import ./constants.nix;
      forEachSystem = func: (nixpkgs.lib.genAttrs constants.allSystems func);
      allSystemConfigurations = import ./systems {inherit self inputs constants;};
    in allSystemConfigurations;
}
