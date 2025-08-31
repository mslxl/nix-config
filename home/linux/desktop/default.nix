{
  pkgs,
  config,
  lib,
  wallpapers,
  ...
} @ args: {
  imports = [
    ./base
    ./hyprland
    ./sway
    ./plasma
    ./niri
  ];

  options.modules.desktop = {
    background = {
      source = lib.mkOption {
        type = lib.types.path;
        default = "${wallpapers}/nix-wallpaper-dracula.png";
      };
      variant = lib.mkOption {
        type = with lib.types; enum ["dark" "light"];
        default = "dark";
      };
    };
    type = lib.mkOption {
      type = lib.types.enum ["hyprland" "sway" "plasma" "niri"];
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
