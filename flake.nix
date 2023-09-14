{
  description = "Mslxl's Nix Config";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        mslxl-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (args: { nixpkgs.overlays = [nur.overlay] ++ import ./overlays args; })

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.mslxl = import ./home/default.nix;
              };
            }
            ./host/xiaoxin2021-laptop/default.nix
          ];
        };
      };
       devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cachix
            lorri
            niv
            nixfmt
            statix
            vulnix
            haskellPackages.dhall-nix
            rnix-lsp
            tokei
          ];
        };
      };
    };
}
