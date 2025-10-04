{
  pkgs,
  system,
  config,
  lib,
  myvars,
  ...
}:
with lib; {
  config = mkIf (config.modules.desktop.type == "sway") {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      brightnessctl
      bottom
    ];

    programs.nm-applet = {
      enable = true;
      indicator = true;
    };

    home-manager.users.${myvars.username} = {
      modules.desktop.type = "sway";
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
