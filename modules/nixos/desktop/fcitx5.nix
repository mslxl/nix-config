{
  pkgs,
  lib,
  config,
  ...
}: with lib; {
  config = lib.mkIf config.modules.desktop.hyprland.enable {
    i18n.inputMethod = {
      enabled= "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool

          fcitx5-gtk
        ];
        waylandFrontend = true;
      };
    };
  };
}
