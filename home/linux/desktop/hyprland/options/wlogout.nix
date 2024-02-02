{
  pkgs,
  lib,
  config,
  ...
}: with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    programs.wlogout.enable = true;
  };
}
