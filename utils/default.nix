{lib, ...}: {
  attrs = import ./attrs.nix {inherit lib;};
  nixosSystem = import ./nixosSystem.nix;
  nixOnDroidSystem = import ./nixOnDroidSystem.nix;
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (
      builtins.attrNames
      (
        lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory")
            || (
              path
              != "default.nix"
              && (lib.strings.hasSuffix ".nix" path)
            )
        )
        (builtins.readDir path)
      )
    );
}
