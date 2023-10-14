{ config, pkgs, ... }:
{

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-rime
      # (pkgs.fcitx5-rime.override {
      #   rimeDataPkgs = [../../overlays/fcitx5/rime-data-flypy];
      # } )
    ];
  };
}