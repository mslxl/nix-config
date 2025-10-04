{
  lib,
  inputs,
  ...
} @ args: let
  inherit (inputs) haumea;

  # Contains all the flake outputs of this system architecture.
  data = haumea.lib.load {
    src = ./src;
    inputs = args;
  };

  # nix file names is redundant, so we remove it.
  dataWithoutPaths = builtins.attrValues data;
in {
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or {}) dataWithoutPaths
  );
  packages = lib.attrsets.mergeAttrsList (map (it: it.packages or {}) dataWithoutPaths);
}
