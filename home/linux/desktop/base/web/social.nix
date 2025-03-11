{
  pkgs,
  nur-pkgs-mslxl,
  ayugram-desktop,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    # "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/tg" = ["com.ayugram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/follow" = ["follow.desktop"];
  };
  home.packages = [
    # pkgs.telegram-desktop
    # pkgs.element-desktop
    pkgs.fluffychat

    pkgs.discord
    # pkgs.follow
    nur-pkgs-mslxl.liteloader-qqnt

    (ayugram-desktop.packages.${pkgs.system}.ayugram-desktop.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [pkgs.makeWrapper];

      postInstall =
        super.postInstall
        or ""
        + ''
          chmod a+rwx "$out/bin/"
          wrapProgram "$out/bin/ayugram-desktop" --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
        '';
    }))
  ];
}
