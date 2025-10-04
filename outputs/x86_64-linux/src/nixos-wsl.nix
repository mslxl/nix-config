{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  niri,
  ...
} @ args: let
  name = "nixos-wsl";

  modules = {
    nixos-modules = map mylib.relativeToRoot [
      "modules/nixos/base.nix"
      "hosts/${name}"
    ];

    home-modules = map mylib.relativeToRoot [
      "home/linux/server.nix"
      "hosts/${name}/home.nix"
    ];
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules // args);
  };

  packages = {
    "${name}" = inputs.self.nixosConfigurations.${name}.config.formats.iso;
  };
}
