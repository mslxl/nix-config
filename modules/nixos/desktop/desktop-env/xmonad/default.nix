{
  pkgs,
  system,
  config,
  lib,
  ...
}:
with lib; {
  options.modules.desktop = {
    xmonad = {
      enable = mkEnableOption "Enable xmonad";
      startup = mkOption {
        type = types.str;
        default = "";
      };
      startupOnce = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf config.modules.desktop.xmonad.enable {
    xdg.portal = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      feh
      xsel
      dmenu
      dunst
      xmobar
      wezterm
      flameshot
    ];

    services.libinput.touchpad.naturalScrolling = true;

    services.xserver = {
      displayManager = {
        startx.enable = true;
      };

      excludePackages = [pkgs.xterm];
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = let
          startup = "${pkgs.writeText "$out/startup" config.modules.desktop.xmonad.startup}";
          startupOnce = "${pkgs.writeText "$out/startupOnce" ''
            dunst &
            kdeconnect-indicator &
            ${pkgs.trayer}/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --height 16 --transparent true --alpha 0 --tint 0x282a36 --widthtype request &
            ${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent &
            ${config.modules.desktop.xmonad.startupOnce}
          ''}";
          xmobarConfigFile = "${./xmobarrc}";
          xmonadCode =
            builtins.replaceStrings
            ["<SPAWN_ON_STARTUP>" "<SPAWN_ONCE_ON_STARTUP>" "<XMOBAR_CONFIG>"]
            [startup startupOnce xmobarConfigFile]
            (builtins.readFile ./xmonad.hs);
        in
          xmonadCode;
        ghcArgs = [
          "-hidir /tmp"
          "-odir /tmp"
        ];
        extraPackages = haskellPackages: [
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
        ];
      };
    };
  };
}
