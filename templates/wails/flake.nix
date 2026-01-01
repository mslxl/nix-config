{
  description = "A Nix-flake-based Wails development environment";

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
      goVersion = 24; # Change this to update the whole stack
      pkgs = import nixpkgs {
        inherit system;
      };
      buildInputs = with pkgs;
        [
          nodejs
          nodejs.pkgs.pnpm
          wails

          # go (version is specified by overlay)
          go
          # goimports, godoc, etc.
          gotools
          # https://github.com/golangci/golangci-lint
          golangci-lint

          just
          nushell
        ]
        ++ (lib.optional pkgs.stdenv.isLinux (with pkgs; [
          gtk3
          webkitgtk
          dbus
          libayatana-appindicator.dev
          alsa-lib.dev
        ]))
        ++ (lib.optional pkgs.stdenv.isDarwin (with pkgs; [
          libiconv
        ]));
    in {
      formatter = pkgs.alejandra;
      overlays.default = final: prev: {
        go = final."go_1_${toString goVersion}";
      };
      # Used by `nix develop`
      devShell = pkgs.mkShell {
        inherit buildInputs;
      };
    });
}
