{
  mylib,
  pkgs,
  lib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  options.modules.desktop = {
    type = lib.mkOption {
      type = lib.types.enum ["hyprland" "sway" "plasma" "niri"];
    };
  };
}
