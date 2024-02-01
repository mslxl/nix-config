{
  pkgs,
  hyprland,
  system,
  lib,
  config,
  ...
}: with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    monitors = mkOption {
      default = [ ",preferred,auto,auto" ];
      type = with types; listOf str;
      description = ''
        Monitor fields in hyprland
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.str;
      description = ''
        Host related config
      '';
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland.packages.${system}.hyprland;
      settings= {
         env = [
          "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
          "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
          "MOZ_WEBRENDER,1"
          # misc
          "_JAVA_AWT_WM_NONREPARENTING,1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORM,wayland"
          "SDL_VIDEODRIVER,wayland"
          "GDK_BACKEND,wayland"
         ];
      };
      extraConfig = let
        monitorSection = builtins.concatStringsSep "\n" (map (field: "monitor=" + field) cfg.monitors);
        confFile = builtins.readFile ../conf/hyprland.conf;
      in ''
        ${monitorSection}
        ${confFile}
        ${cfg.extraConfig}

        exec-once = fcitx5 -d --replace
        exec-once = hyprctl setcursor Bibata-Modern-Ice 24
        exec-once = nm-applet
        exec-once = wl-paste --watch cliphist store
        exec-once = foot -s
        exec-once = kdeconnect-indicator
      '';
    };
  };

}
