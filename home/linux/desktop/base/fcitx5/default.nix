{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime

        fcitx5-configtool
        fcitx5-fluent

        fcitx5-lua
        fcitx5-gtk
      ];
      waylandFrontend = true;
    };
  };

  home.activation.cleanFcitxRime = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${config.xdg.dataHome}/fcitx5/rime/" ]; then
      echo "Clean old rime data: ${config.xdg.dataHome}/fcitx5/rime/..."
      rm -rf "${config.xdg.dataHome}/fcitx5/rime/"
    fi
  '';
}
