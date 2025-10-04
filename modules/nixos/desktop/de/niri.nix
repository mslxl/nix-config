{
  pkgs,
  system,
  config,
  lib,
  myvars,
  ...
}:
with lib; {
  config = mkIf (config.modules.desktop.type == "niri") {
    programs.nm-applet = {
      enable = true;
      indicator = true;
    };
    home-manager.users.${myvars.username} = {
      modules.desktop.type = "niri";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      brightnessctl
      bottom
    ];
  };
}
