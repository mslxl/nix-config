{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (config.modules.desktop.type == "hyprland") {
    xdg.configFile."electron-flags.conf".text = ''
      --enable-wayland-im
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
  };
}
