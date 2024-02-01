{pkgs, ...}: {

  xdg.configFile."rofi" = {
    source = ./config;
    force = true;
  };
  programs.rofi = {
    enable = true;
  };
}
