{
  lib,
  pkgs,
  ...
}: {
  xdg.mimeApps.defaultApplications = lib.mkIf (!pkgs.stdenv.isDarwin) {
    "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
  };

  home.packages = with pkgs; [
    discord
    qq
  ];
}
