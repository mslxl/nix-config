{
  pkgs,
  system,
  lib,
  config,
  ...
}: {
  options.modules.wakatime.enable = lib.mkEnableOption "Enable wakatime";

  config = lib.mkIf config.modules.wakatime.enable {
    home.file.".wakatime.cfg".text = ''
      [settings]
      api_url = https://wakatime.mslxl.com/api
      api_key = fb90890d-11af-4808-b9f2-3de155d327c5
      status_bar_enabled = true
      debug = false
      proxy =
    '';
    home.packages = with pkgs; [
      wakatime-cli
    ];
  };
}
