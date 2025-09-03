{pkgs, ...}: {
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
    (pkgs.qq.override {
      commandLineArgs = [
        # Force to run on Wayland
        # "--ozone-platform-hint=auto"
        # "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })

    # pkgs.telegram-desktop
    (pkgs.wechat.overrideAttrs (super: {
      buildInputs = [pkgs.makeWrapper];

      postInstall =
        (super.postInstall or "")
        + ''
          wrapProgram $out/bin/wechat  --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
        '';
    }))
    (pkgs.ayugram-desktop.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [pkgs.makeWrapper];

      postInstall =
        (super.postInstall or "")
        + ''
          chmod a+rwx "$out/bin/"
          wrapProgram "$out/bin/AyuGram" --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
        '';
    }))
  ];
}
