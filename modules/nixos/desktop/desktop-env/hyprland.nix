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

      # Hyprland has its own portal xdg-desktop-portal-hyprland and does not need the wlr portal.
      # https://github.com/NixOS/nixpkgs/pull/315827
      wlr.enable = false;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-wlr
        (xdg-desktop-portal-hyprland.override {
          hyprland = hyprland.packages.${system}.hyprland;
        })
      ];
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      cliphist
    ];

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${system}.hyprland;
      xwayland.enable = true;
    };
    security.pam.services.swaylock = {};
  };
}
