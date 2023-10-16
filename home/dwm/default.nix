{pkgs, wallpaper, ...}: {

  imports = [
    ./rofi
    ./picom
  ];

  xdg.configFile.".dwm/wallpaper" = {
    source = wallpaper;
    recursive = true;
  };

  xdg.configFile.".dwm/autostart.sh" = {
    source = ./autostart.sh;
    executable = true;
  };
  xdg.configFile.".dwm/autostart_blocking.sh" = {
    source = ./autostart_blocking.sh;
    executable = true;
  };
}
