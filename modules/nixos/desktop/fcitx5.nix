{
  pkgs,
  lib,
  config,
  ...
}: with lib; let
in  {
  i18n.inputMethod = {
    enabled= "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-configtool
        fcitx5-gtk
      ];
    };
  };
}
