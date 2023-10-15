{
  description = "Mslxl's Nix Config";


  outputs = { nixpkgs, home-manager, nur, xddxdd, ... }:
    let
      username = "mslxl";
      userFullname = "mslxl";
      useremail = "i@mslxl.com";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        overlays = (import ./overlays {}) ++ [nur.overlay];
        system = system;
        config.allowUnfree = true;
      };
      pkgs-xddxdd = import xddxdd {
        inherit pkgs;
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = 
      let 
        specialArgs = {
          inherit username userFullname useremail;
          inherit pkgs;
          inherit pkgs-xddxdd;
        };
      in {
        mslxl-laptop = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./host/xiaoxin2021-laptop
            ./modules/desktop-plasma5.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username} = import ./home/desktop-plasma5.nix;
              };
            }
          ];
        };
      };
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
    xddxdd.url = "github:xddxdd/nur-packages";
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.ustc.edu.cn/nix-channels/store"
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
}
