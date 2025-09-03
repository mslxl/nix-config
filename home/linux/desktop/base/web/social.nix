{
  pkgs,
  nur-pkgs-mslxl,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    # "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/tg" = ["com.ayugram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/follow" = ["follow.desktop"];
  };
  home.packages = [
    # pkgs.element-desktop

    pkgs.discord
    pkgs.folo
    # nur-pkgs-mslxl.liteloader-qqnt
    # nur-pkgs-mslxl.qqnt
    (pkgs.qq.override {
      commandLineArgs = [
        # Force to run on Wayland
        # "--ozone-platform-hint=auto"
        # "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })
    pkgs.wechat
    # pkgs.telegram-desktop
    pkgs.ayugram-desktop
  ];
}
