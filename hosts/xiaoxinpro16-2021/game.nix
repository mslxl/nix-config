{
  config,
  lib,
  pkgs,
  pkgs-stable,
  username,
  myutils,
  ...
}: {
  specialisation = {
    gamimg-time.configuration = {
      services.tlp.enable = lib.mkForce false;
      hardware.nvidia = {
        powerManagement = {
          enable = lib.mkForce false;
          finegrained = lib.mkForce false;
        };
        prime = {
          sync.enable = true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };

      hardware.opengl = {
        extraPackages = [pkgs.amdvlk];
        extraPackages32 = [pkgs.driversi686Linux.amdvlk];
      };

      xdg.portal = {
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      #TODO: optimize configuration below and move it to module
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = lib.mkForce false;
      programs.hyprland.enable = lib.mkForce false;
      services.xserver.displayManager.gdm.enable = true;
      i18n.inputMethod.fcitx5.plasma6Support = true;

      # use command below
      # - gamemoderun %command%
      # - mangohud %command%
      # - gamescope %command%
      programs.steam = {
        enable = lib.mkForce true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };
      services.keyd.keyboards.default.settings.main = lib.mkForce {};
      environment.systemPackages = with pkgs; [
        wezterm

        mangohud
        protonup

        lutris
        bottles
      ];
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${username}/.steam/root/compatibilitytools.d";
      };

      programs.gamemode.enable = true;

      virtualisation = {
        docker.enable = lib.mkForce false;
        waydroid.enable = lib.mkForce false;
        libvirtd.enable = lib.mkForce false;
      };
      services.spice-vdagentd.enable = lib.mkForce false;
    };
  };
}
