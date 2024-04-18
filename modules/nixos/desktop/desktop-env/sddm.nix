{
  pkgs,
  config,
  wallpaper,
  lib,
  nix-colors,
  ...
}:
with lib; {
  options.modules.desktop = {
    sddm = {
      enable = mkEnableOption "Enable sddm";
      bg = mkOption {
        type = types.path;
        default = ../../../nix-wallpaper-dracula.png;
      };
      variant = lib.mkOption {
        type = with lib.types; enum ["dark" "light"];
        default = "dark";
      };
    };
  };

  config = mkIf config.modules.desktop.sddm.enable {
    environment.systemPackages = with pkgs; [
      (callPackage ../../../../pkgs/sddm-themes.nix {
        backgroundPicture = config.modules.desktop.sddm.bg;
        colors = let
          scheme =
            ((nix-colors.lib.contrib {inherit pkgs;}).colorSchemeFromPicture {
              path = config.modules.desktop.sddm.bg;
              variant = config.modules.desktop.sddm.variant;
            })
            .palette;
        in {
          main = "white";
          accent = "#${scheme.base0E}";
          background = "#${scheme.base07}";
        };
      })
      .sddm-sugar-dark
      libsForQt5.qt5.qtgraphicaleffects #required for sugar candy
      brightnessctl
    ];

    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      # wayland.enable = true;
      autoNumlock = true;
      theme = "sugar-dark";
    };
  };
}
