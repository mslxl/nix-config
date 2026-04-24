# Error happens? back to plasma in temp
{
  plasma-manager,
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib; {
  config = mkMerge [
    {
      home-manager.users.${myvars.username}.imports = [
        plasma-manager.homeModules.plasma-manager
      ];
    }

    (mkIf (config.modules.desktop.type == "plasma") {
      services.power-profiles-daemon.enable = true;
      services.tlp.enable = mkForce false;
      services.desktopManager.plasma6.enable = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard
        bottom
      ];
      home-manager.users.${myvars.username} = {
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
    })
  ];
}
