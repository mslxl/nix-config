{
  pkgs,
  config,
  lib,
  ...
}@args : {

  imports = [
    ./base
    ./hyprland
  ];

  options.modules.desktop.background = {
    source = lib.mkOption {
      type = lib.types.path;
      default = ../../../wallpaper/lake-sunrise.jpg;
    };
    variant = lib.mkOption {
      type = with lib.types; enum ["dark" "light"];
      default = "dark";
    };
  };
}
