{
  pkgs,
  config,
  lib,
  nur-pkgs-mslxl,
  ...
}: {
  config = lib.mkIf (config.modules.aria.daemon.enable && config.modules.aria.enable) {
    home.packages = [
      nur-pkgs-mslxl.ariang-native
    ];
  };
}
