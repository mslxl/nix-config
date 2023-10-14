{ config, pkgs, ... }:

{
  # This will install compiler permanently
  # Some program install nix-shell would be better

  imports = [
    ./python.nix
  ];
}
