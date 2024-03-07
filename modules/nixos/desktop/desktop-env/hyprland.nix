{
  hyprland,
  pkgs,
  system,
  config,
  lib,
  ...
}:
with lib; {
  options.modules.desktop = {
    hyprland = {
      enable = mkEnableOption "Enable hyprland";
    };
  };

  config = mkIf config.modules.desktop.hyprland.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        (xdg-desktop-portal-hyprland.override {
          hyprland = hyprland.packages.${system}.hyprland;
        })
      ];
    };

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${system}.hyprland;
      xwayland.enable = true;
    };
    security.pam.services.swaylock = {};
  };
}
