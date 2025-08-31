{
  myutils,
  pkgs,
  lib,
  config,
  ...
} @ args: {
  imports = [
    ./options
  ];

  config = lib.mkIf (config.modules.desktop.type == "sway") (import ./apps args);
}
