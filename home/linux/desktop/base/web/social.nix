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
    nur-pkgs-mslxl.qqnt
    # pkgs.telegram-desktop
    (pkgs.ayugram-desktop.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [pkgs.makeWrapper];

      postInstall =
        super.postInstall
        or ""
        + ''
          chmod a+rwx "$out/bin/"
          wrapProgram "$out/bin/AyuGram" --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
        '';
    }))
  ];
}
