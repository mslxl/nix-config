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
  # 鈴蘭
  name = "suzuran";

  modules = {
    nixos-modules = map mylib.relativeToRoot [
      "modules/nixos/desktop.nix"
      "hosts/${name}"
    ];

    home-modules = map mylib.relativeToRoot [
      "home/linux/desktop.nix"
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
