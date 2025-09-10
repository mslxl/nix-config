{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  addons = with pkgs; [
    fcitx5-rime

    fcitx5-configtool
    # fcitx5-fluent

    fcitx5-lua
    fcitx5-gtk
    libsForQt5.fcitx5-qt
    kdePackages.fcitx5-qt
  ];
in {
  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;
  };

  # home.activation.clean-fcitx-rime-data = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   if [ -d "${config.xdg.dataHome}/fcitx5/rime/" ]; then
  #     rm -rf "${config.xdg.dataHome}/fcitx5/rime/"
  #   fi
  #   if pgrep -f "fcitx5" > /dev/null ; then
  #     ${pkgs.libnotify}/bin/notify-send fcitx5 "Restarting..."
  #     pkill fcitx5
  #     fcitx5 -d --replace
  #     sleep 3
  #     # https://github.com/fcitx/fcitx5-rime/issues/54#issuecomment-1736621316
  #     ${pkgs.dbus}/bin/dbus-send --type=method_call --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.SetConfig string:fcitx://config/addon/rime/deploy variant:string:"" || true
  #   fi
  # '';

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      inherit addons;
      waylandFrontend = true;
    };
  };
}
