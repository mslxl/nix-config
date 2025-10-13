{
  lib,
  inputs,
  darwin-modules,
  home-modules ? [],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}: let
  inherit (inputs) nixpkgs-darwin home-manager nix-darwin;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules =
      darwin-modules
      ++ [
        inputs.mac-app-util.darwinModules.default
        (
          {lib, ...}: {
            nixpkgs.pkgs = import nixpkgs-darwin {
              inherit system; # refer the `sysytem` parameter from outer scope recursively

              config.allowUnfree = true;
            };
          }
        )
      ]
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0) [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "home-manager.backup";

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.sharedModules = [
              inputs.mac-app-util.homeManagerModules.default
            ];
            home-manager.users."${myvars.username}".imports = home-modules;
          }
        ]
      );
  }
