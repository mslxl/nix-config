{pkgs, ...}:

{
    home.packages = with pkgs; [
        polybar
        pavucontrol
    ];
    xdg.configFile = {
        "polybar/config.ini".source = ./config.ini;
        "polybar/script" = {
            source = ./script;
            recursive = true;
            executable = true;
        };
    };
}