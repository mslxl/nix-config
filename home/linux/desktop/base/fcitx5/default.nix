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
}
