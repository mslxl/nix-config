{
  myutils,
  pkgs,
  lib,
  config,
  ...
} @ args:
with lib; {
  imports = [
    ./options
  ];

  config = mkIf (config.modules.desktop.type == "hyprland") (import ./apps args);
}
