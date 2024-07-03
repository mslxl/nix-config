{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
      --enable-wayland-im
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
  };
}
