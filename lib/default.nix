{lib, ...}: {
  nixosSystem = import ./nixosSystem.nix;
  macosSystem = import ./macosSystem.nix;

  attrs = import ./attrs.nix {inherit lib;};

  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;
  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        ) (builtins.readDir path)
      )
    );
}
