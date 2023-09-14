{ config, pkgs, ... }:

{
  # This will install compiler permanently
  # Some program install nix-shell would be better

  imports = [
    ./cpp.nix
    ./python.nix
    ./go.nix
    ./nodejs.nix
    ./haskell.nix
    ./ocaml.nix
    ./rust.nix
  ];

}
