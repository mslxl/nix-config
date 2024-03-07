{
  pkgs,
  system,
  config,
  lib,
  ...
}:
with lib; {
  options.modules.desktop = {
    sway = {
      enable = mkEnableOption "Enable sway";
    };
  };

  config = mkIf config.modules.desktop.sway.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };

    programs.sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraOptions = [
        "--unsupported-gpu"
      ];
      extraSessionCommands = ''
        export QT_QPA_PLATFORM=wayland-egl
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
    security.pam.services.swaylock = {};
  };
}
