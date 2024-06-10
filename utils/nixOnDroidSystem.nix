{
  nixpkgs,
  home-manager,
  system,
  specialArgs,
  nixos-modules,
  home-module ? null,
  ...
}: let
  inherit (specialArgs) username;
in
  nixpkgs.nix-on-droid.lib.nixOnDroidConfiguration {
    inherit system specialArgs;
    modules =
      nixos-modules
      ++ (
        if (home-module != null)
        then [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users."${username}" = home-module;
          }
        ]
        else []
      );
  }
