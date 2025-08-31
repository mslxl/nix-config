{pkgs, ...}: {
  programs.foot = {
    enable = false;
    server.enable = false;
    settings = {
      main = {
        # term = "xterm-256color";

        font = "FiraCode Nerd Font:size=12";
        dpi-aware = "no";
        pad = "15x15";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      key-bindings = {
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
      };
    };
  };
}
