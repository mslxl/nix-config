{
  nix-colors,
  lib,
  config,
  pkgs,
  ...
}: let 
colors = ((nix-colors.lib.contrib {inherit pkgs;}).colorSchemeFromPicture {
  path = config.modules.desktop.background.source;
  variant = config.modules.desktop.background.variant;
}).palette;
in {
  window = {
    border = 3;
  };
  gaps = {
    inner = 10;
    outer = 14;
  };
  fonts = {
    names = [ "Fira Sans Semibold" "FiraCode Nerd Font" "FontAwesome" "Roboto" ];
    size = 12.0;
  };
  bars = [
    {
      colors = {
        inactiveWorkspace = {
          background = "#${colors.base05}";
          border = "#${colors.base05}";
          text = "#ffffff";
        };
        focusedWorkspace = {
          background = "#${colors.base05}";
          border = "#${colors.base05}";
          text = "#ffffff";
        };
      };
    }
  ];
  colors = {
    focused = {
      background = "#${colors.base0B}";
      border = "#${colors.base0B}";
      text = "#${colors.base00}";
      childBorder = "#${colors.base0F}";
      indicator = "#${colors.base0F}";
    };
  };
}
