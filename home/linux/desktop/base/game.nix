{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.game = {
    minecraft.enable = lib.mkEnableOption "Enable prism launcher";
    steam.enable = lib.mkEnableOption "Enable steam";
    osu.enable = lib.mkEnableOption "Enable OSU!";
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.game.minecraft.enable {
      home.packages = with pkgs; [
        (prismlauncher.override {jdks = [zulu8 jdk21];})
      ];
    })

    (lib.mkIf config.modules.game.steam.enable {
      home.packages = with pkgs; [
        steam
      ];
    })

    (lib.mkIf config.modules.game.osu.enable {
      home.packages = with pkgs; [
        osu-lazer
      ];
    })
  ];
}
