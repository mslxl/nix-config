{
  pkgs,
  config,
  lib,
  nur-pkgs-mslxl,
  ...
}: {
  config = lib.mkIf config.modules.aria.daemon.enable {
    home.packages = [
      nur-pkgs-mslxl.ariang-native
    ];
  };
}
