{
  pkgs,
  config,
  lib,
  ...
}@args : {

  imports = [
    ./base
    ./hyprland
  ];


}
