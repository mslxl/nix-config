{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  plasma6Support = false;

  addons = with pkgs; [
    fcitx5-rime

    # fcitx5-configtool
    fcitx5-fluent

    fcitx5-lua
    fcitx5-gtk
    libsForQt5.fcitx5-qt
  ];

  fcitx5Package =
    if plasma6Support then
      pkgs.qt6Packages.fcitx5-with-addons.override { inherit addons; }
    else
      pkgs.libsForQt5.fcitx5-with-addons.override { inherit addons; };

in {
  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;
  };
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./classicui.conf;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      inherit addons;
      fcitx5-with-addons = fcitx5Package;
      waylandFrontend = true;
    };
  };

  home.activation.cleanFcitxRime = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${config.xdg.dataHome}/fcitx5/rime/" ]; then
      echo "Clean old rime data: ${config.xdg.dataHome}/fcitx5/rime/..."
      rm -rf "${config.xdg.dataHome}/fcitx5/rime/"

      # https://github.com/fcitx/fcitx5-rime/issues/54#issuecomment-1736621316
      ${pkgs.dbus}/bin/dbus-send --type=method_call --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.SetConfig string:fcitx://config/addon/rime/deploy variant:string:""
    fi
  '';
}
