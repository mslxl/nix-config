{pkgs, wallpaper, ...}: {

  imports = [
    ./rofi
    ./picom
    ./polybar
  ];

  home.file.".dwm/wallpaper" = {
    source = wallpaper;
    recursive = true;
  };

  home.file.".dwm/autostart.sh" = {
    source = ./autostart.sh;
    executable = true;
  };
  home.file.".dwm/autostart_blocking.sh" = {
    source = ./autostart_blocking.sh;
    executable = true;
  };

  home.file.".dwm/restart_polybar.sh" = {
    source = ./restart_polybar.sh;
    executable = true;
  };
}
