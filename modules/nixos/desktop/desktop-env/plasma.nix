# Error happens? back to plasma in temp
{
  pkgs,
  config,
  lib,
  ...
}: with lib; {
  options.modules.desktop.plasma = {
    enable = mkEnableOption "Enable plasma";
  };

  config = mkIf config.modules.desktop.plasma.enable {
    services.power-profiles-daemon.enable = true;
    services.tlp.enable = mkForce false;
    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
    };
    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
      kmail
      kate
      okular
      elisa
    ];
  };
}
