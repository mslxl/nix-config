{
  hyprland,
  pkgs,
  system,
  config,
  lib,
  myvars,
  ...
}:
with lib; {
  config = mkIf (config.modules.desktop.type == "hyprland") {
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

    programs.nm-applet = {
      enable = true;
      indicator = true;
    };
    home-manager.users.${myvars.username} = {
      modules.desktop.type = "hyprland";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      brightnessctl
      bottom
    ];

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${system}.hyprland;
      xwayland.enable = true;
    };
    security.pam.services.swaylock = {};
  };
}
