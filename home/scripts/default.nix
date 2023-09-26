{ config, lib, pkgs, ... }:
let
  files = builtins.trace (lib.filesystem.listFilesRecursive ./bin);
in
{
  inherit (lib.lists.forEach files (
    name: 
      home.file."${name}" = {
        source = name;
      };
    ));
}
