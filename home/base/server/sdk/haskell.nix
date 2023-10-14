{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ghc
    stack
    haskellPackages.haskell-language-server
  ];
}
