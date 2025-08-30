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
in {
  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;
  };
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./classicui.conf;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      inherit addons;
      waylandFrontend = true;
    };
  };
}
