{
  description = "Mslxl's Nix Config";


  outputs = inputs @ { nixpkgs, home-manager, nur, xddxdd, astronvim, ... }:
    let
      username = "mslxl";
      userFullname = "mslxl";
      useremail = "i@mslxl.com";
      system = "x86_64-linux";
      overlays = (import ./overlays {}) ++ [nur.overlay];
      pkgs = import nixpkgs {
        inherit overlays system;
        config.allowUnfree = true;
      };
      pkgs-xddxdd = import xddxdd {
        inherit pkgs system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = 
      let 
        specialArgs = {
          inherit username userFullname useremail;
          inherit system;
          inherit pkgs;
          inherit pkgs-xddxdd;
        } // inputs;
      in {
        mslxl-laptop = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./host/xiaoxin2021-laptop
            ./modules/desktop-dwm
            ./modules/virt.nix
            ./modules/steam.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username} = import ./home/desktop-dwm.nix;
              };
            }
          ];
        };
      };
    };

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    # pkgs

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    xddxdd.url = "github:xddxdd/nur-packages";
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";


    # program

    astronvim = {
      url = "github:AstroNvim/AstroNvim";
      flake = false;
    };

    wallpaper = {
      url = "./wallpaper";
      flake = false;
    };
    myscript = {
      url = "./script";
      flake = false;
    };
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
