{
  myutils,
  pkgs,
  lib,
  config,
  ...
} @ args:
with lib; {
  imports = [./options];

  options.modules.desktop.sway = {
    enable = mkEnableOption "Enable sway";
  };
  config = mkIf config.modules.desktop.sway.enable ((import ./values args) // (import ../base-wayland-tile args));
}
