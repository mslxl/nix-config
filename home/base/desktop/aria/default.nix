{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.aria.daemon.enable {
    home.packages = with pkgs; [
      ariang
    ];
  };
}
