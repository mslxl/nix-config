{
  pkgs,
  mylib,
  config,
  nix-colors,
  ...
}: let
  colorScheme =
    ((nix-colors.lib.contrib {inherit pkgs;}).colorSchemeFromPicture {
      path = config.modules.desktop.background.source;
      variant = config.modules.desktop.background.variant;
    })
      .palette;

  currentWallpaper = ''
    * { current-image: url("${config.modules.desktop.background.source}", height); }
  '';
  colors = ''
    * {
        background: rgba(0,0,1,0.5);
        foreground: #FFFFFF;
        color0:     #${colorScheme.base00};
        color1:     #${colorScheme.base01};
        color2:     #${colorScheme.base02};
        color3:     #${colorScheme.base03};
        color4:     #${colorScheme.base04};
        color5:     #${colorScheme.base05};
        color6:     #${colorScheme.base06};
        color7:     #${colorScheme.base07};
        color8:     #${colorScheme.base08};
        color9:     #${colorScheme.base09};
        color10:    #${colorScheme.base0A};
        color11:    #${colorScheme.base0B};
        color12:    #${colorScheme.base0C};
        color13:    #${colorScheme.base0D};
        color14:    #${colorScheme.base0E};
        color15:    #${colorScheme.base0F};
    }
  '';
in {
  xdg.configFile = mylib.attrs.mergeAttrsList (
    map
    (
      name: {
        "rofi/${name}" = {
          text =
            ''
              ${currentWallpaper}
              ${colors}
            ''
            + (builtins.readFile ./config/${name});
          force = true;
        };
      }
    )
    (builtins.attrNames (builtins.readDir ./config))
  );

  programs.rofi = {
    enable = true;
  };
}
