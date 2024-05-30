{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.game = {
    minecraft.enable = lib.mkEnableOption "Enable prism launcher";
    steam.enable = lib.mkEnableOption "Enable steam";
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.game.minecraft.enable {
      home.packages = with pkgs; [
        (prismlauncher.override {jdks = [zulu8 zulu17 jdk21];})
      ];
    })

    (lib.mkIf config.modules.game.steam.enable {
      home.packages = with pkgs; [
        steam
      ];
    })
  ];
}
