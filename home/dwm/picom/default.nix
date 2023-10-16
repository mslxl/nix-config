{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        picom
    ];
    xdg.configFile."picom/config.conf".source = ./picom.conf;
}
