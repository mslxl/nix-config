{
  pkgs,
  nur-pkgs-mslxl,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
  };
  home.packages = [
    pkgs.telegram-desktop
    pkgs.discord
    nur-pkgs-mslxl.liteloader-qqnt
  ];
}
