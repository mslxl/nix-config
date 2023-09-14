{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python312
    yapf
  ];
}
