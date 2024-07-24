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
  nixpkgs-config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # For pkgs.wechat-uos
      "openssl"
      "openssl-1.1.1w"
    ];
  };
  specialArgsForSystem = system:
    rec {
      inherit system;
      inherit (constants) username useremail;
      inherit myutils;
      pkgs-unstable = import inputs.nixpkgs {
        inherit system;
        config = nixpkgs-config;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config = nixpkgs-config;
      };
      pkgs = pkgs-unstable;
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
    suzuran = nixosSystem (profiles.suzuran // base_args.x64_system);
    nixos-wsl = nixosSystem (profiles.nixos-wsl // base_args.x64_system);
  };
}
