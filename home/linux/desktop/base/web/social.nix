{
  pkgs,
  nur-pkgs-mslxl,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
  };
  home.packages = [
    pkgs.telegram-desktop
    nur-pkgs-mslxl.liteloader-qqnt
  ];
}
