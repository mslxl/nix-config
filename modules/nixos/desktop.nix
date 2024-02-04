{
  hyprland,
  pkgs,
  system,
  config,
  wallpaper,
  lib,
  nix-colors,
  ...
} : with lib; {
  imports = [
    ./desktop
  ];


  options.modules.desktop = {
    hyprland = {
      enable = mkEnableOption "Enable hyprland";
    };
    sddm = {
      bg = mkOption {
        type = types.path;
        default = ../../nix-wallpaper-dracula.png;
      };
      variant = lib.mkOption {
        type = with lib.types; enum ["dark" "light"];
        default = "dark";
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      bottom
    ];
    programs.nm-applet = {
      enable = true;
      indicator = true;
    };
  }
  // mkIf config.modules.desktop.hyprland.enable {
    environment.systemPackages = with pkgs; [
      (callPackage ../../pkgs/sddm-themes.nix {
        backgroundPicture = config.modules.desktop.sddm.bg;
        colors = let
          scheme = ((nix-colors.lib.contrib {inherit pkgs;}).colorSchemeFromPicture {
            path = config.modules.desktop.sddm.bg;
            variant = config.modules.desktop.sddm.variant;
          }).palette;
        in {
          main = "white";
          accent = "#${scheme.base0E}";
          background ="#${scheme.base07}";
        };
      }).sddm-sugar-dark
      libsForQt5.qt5.qtgraphicaleffects #required for sugar candy
      brightnessctl
      wl-clipboard
      cliphist
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
