{
  hyprland,
  pkgs,
  system,
  config,
  lib,
  ...
} : with lib; {
  imports = [
    ./desktop
  ];


  options.modules.desktop = {
    hyprland = {
      enable = mkEnableOption "Enable hyprland";
    };
    sddm.bg = mkOption {
      type = types.path;
      default = ../../wallpaper/adwaita-d.jpg;
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  }
  // mkIf config.modules.desktop.hyprland.enable {
    environment.systemPackages = with pkgs; [
      (callPackage ../../pkgs/sddm-themes.nix {
        backgroundPicture = config.modules.desktop.sddm.bg;
      }).sddm-sugar-dark
      libsForQt5.qt5.qtgraphicaleffects #required for sugar candy
    ];

    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        # wayland.enable = true;
        autoNumlock = true;
        theme = "sugar-dark";
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
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
