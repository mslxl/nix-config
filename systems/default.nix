{
  self,
  inputs,
  constants,
}: let
  inherit (inputs.nixpkgs) lib;
  myutils = import ../utils {inherit lib;};
  profiles = import ./profiles.nix {
    inherit inputs;
  };
  specialArgsForSystem = system:
    rec {
      inherit system;
      inherit (constants) username useremail;
      inherit myutils;
      nix-colors = inputs.nix-colors;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      nur-pkgs-mslxl = import inputs.nur-mslxl {
        pkgs = pkgs-unstable;
      };
      nur-pkgs = import inputs.nur {
        nurpkgs = pkgs-unstable;
        pkgs = pkgs-unstable;
      };
    }
    // inputs;
  allSystemSpecialArgs = myutils.attrs.mapAttrs (_: specialArgsForSystem) constants.allSystemAttrs;
  args = myutils.attrs.mergeAttrsList [
    inputs
    constants
    profiles
    {inherit self lib myutils allSystemSpecialArgs;}
  ];
in {
  nixosConfigurations = with args;
  with myutils;
  with allSystemAttrs; let
    base_args =
      myutils.attrs.mapAttrs (system-key: (system: {
        inherit home-manager;
        inherit nixpkgs;
        inherit system;
        specialArgs = allSystemSpecialArgs.${system-key};
      }))
      allSystemAttrs;
  in {
    mslxl-xiaoxinpro16-2021 = nixosSystem (profiles.xiaoxinpro16-2021 // base_args.x64_system);
    nixos-wsl = nixosSystem (profiles.nixos-wsl // base_args.x64_system);
  };
}
