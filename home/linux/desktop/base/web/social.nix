{
  pkgs,
  nur-pkgs-mslxl,
  ayugram-desktop,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
  };
  home.packages = [
    pkgs.telegram-desktop
    # TODO: its hash check failure
    # ayugram-desktop.packages.${pkgs.system}.default
    pkgs.discord
    nur-pkgs-mslxl.liteloader-qqnt
  ];
}
