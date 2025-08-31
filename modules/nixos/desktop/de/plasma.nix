# Error happens? back to plasma in temp
{
  pkgs,
  config,
  lib,
  username,
  ...
}:
with lib; {
  config = mkIf (config.modules.desktop.type == "plasma") {
    services.power-profiles-daemon.enable = true;
    services.tlp.enable = mkForce false;
    services.desktopManager.plasma6.enable = true;
    environment.systemPackages = with pkgs; [
      ghostty
      wl-clipboard
      bottom
    ];
    home-manager.users.${username} = {
      modules.desktop.type = "plasma";
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      kmail
      kate
      kwallet
      okular
      elisa
    ];
  };
}
