let desktop_base = {
      nixos-modules = [
        ../modules/base.nix
        ../modules/nixos/desktop.nix
      ];
      home-module.imports = [
        ../home/linux/desktop.nix
      ];
};
in {
  xiaoxinpro16-2021 = {
    nixos-modules =
      [
        ../hosts/xiaoxinpro16-2021
      ]
      ++ desktop_base.nixos-modules;
    home-module.imports = desktop_base.home-module.imports;
  };
}
