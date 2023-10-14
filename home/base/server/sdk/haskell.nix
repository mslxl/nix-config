{ config, pkgs, ... }:

{
  # Maybe use falke and direnv is a better choice?
  home.packages = with pkgs; [
    ghc
    stack
    haskellPackages.haskell-language-server
  ];
}
