{
  myutils,
  pkgs,
  lib,
  config,
  ...
}@args : with lib; {
  imports = [ ./options ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland";
  };
  config = mkIf config.modules.desktop.hyprland.enable (import ./values args);
}
