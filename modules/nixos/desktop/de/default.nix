{
  myutils,
  pkgs,
  lib,
  ...
}: {
  imports = myutils.scanPaths ./.;

  options.modules.desktop = {
    type = lib.mkOption {
      type = lib.types.enum ["hyprland" "sway" "plasma" "niri"];
    };
  };
}
