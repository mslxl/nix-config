{
  pkgs,
  config,
  lib,
  wallpaper,
  ...
} @ args: {
  imports = [
    ./base
    ./hyprland
    ./sway
  ];

  options.modules.desktop = {
    background = {
      source = lib.mkOption {
        type = lib.types.path;
        default = ../../../nix-wallpaper-dracula.png;
      };
      variant = lib.mkOption {
        type = with lib.types; enum ["dark" "light"];
        default = "dark";
      };
    };
    exec = {
      once = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Exec at first start
        '';
      };
      always = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Exec on every refresh
        '';
      };
    };
  };
  config = {
    xdg.mimeApps.enable = true;

    home.packages = with pkgs; [
      perl538Packages.FileMimeInfo
    ];
  };
}
