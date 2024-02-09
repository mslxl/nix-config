{
    pkgs,
    config,
    lib,
    ...
} @args : with lib; {
    config = mkIf config.modules.desktop.sway.enable {
        wayland.windowManager.sway = {
            enable = true;
            package = null;
            config = {
                startup = [
                    {command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
                    {command = "fcitx5 -d --replace";}
                    {command = "waybar"; }
                    {command = "dunst"; }
                    {command = "foot -s"; always = true;}
                ];
                terminal = "${pkgs.foot}/bin/foot";
                up = "k";
                down = "j";
                left = "h";
                right = "l";
                keybindings = let
                        modifier = config.wayland.windowManager.sway.config.modifier;
                    in lib.mkOptionDefault {
                        "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
                        "${modifier}+Shift+c" = "kill";
                        "${modifier}+Ctrl+Return" = "exec rofi -show drun"; 
                    };
                # extraConfig = ''

                # '';
            }
            // (import ./theme.nix args);
        };


    };
}
