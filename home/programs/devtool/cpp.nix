{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (hiPrio gcc)
    gdb
    clang
    clang-tools
    cling
  ];

}
