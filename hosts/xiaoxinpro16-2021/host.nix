{pkgs, ...}: {
  modules.desktop = {
    hyprland = {
      enable = true;
    };
    sddm = {
      enable = true;
      bg = ../../wallpaper/pixiv-104537131.png;
    };
    sway = {
      enable = false;
    };
    plasma = {
      enable = false;
    };
  };
}
