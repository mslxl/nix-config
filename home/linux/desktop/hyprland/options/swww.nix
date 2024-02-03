{
  pkgs,
  lib,
  config,
  ...
}: with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
    ];
    home.activation.swww-refresh = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.swww}/bin/swww img ${config.modules.desktop.background.source}
    '';
  };
}
