{
  description = "Mslxl's NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-mslxl.url = "github:mslxl/nur-pkgs";
    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";
    secrets = {
      url = "git+ssh://git@github.com/mslxl/secrets.git?shallow=1";
      flake = false;
    };

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

    wallpapers = {
      url = "https://github.com/mslxl/wallpapers/archive/main.tar.gz";
      flake = false;
    };
    sticky-bucket.url = "github:mslxl/sticky-bucket";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    waybar.url = "github:Alexays/Waybar";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    constants = import ./constants.nix;
    forEachSystem = func: (nixpkgs.lib.genAttrs constants.allSystems func);
    allSystemConfigurations = import ./systems {inherit self inputs constants;};
  in
    allSystemConfigurations
    // {
      formatter = forEachSystem (
        system: nixpkgs.legacyPackages.${system}.alejandra
      );
      devShells = forEachSystem (system: let
        devPkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in {
        default = devPkgs.mkShell {
          packages = with devPkgs; [
            just
            nushell
          ];
        };
      });
    };
}
