{
  description = "A Nix-flake-based Nodejs development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      buildInputs = with pkgs;
        [
          nodejs
          nodejs.pkgs.pnpm

          just
          nushell
        ];
    in {
      formatter = pkgs.alejandra;
      # Used by `nix develop`
      devShell = pkgs.mkShell {
        inherit buildInputs;
      };
    });
}
