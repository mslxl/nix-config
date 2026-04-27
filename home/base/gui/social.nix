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
    (
      if pkgs.stdenv.isDarwin
      then wechat
      else wechat.overrideAttrs (super: {
        buildInputs = [pkgs.makeWrapper];

        postInstall =
          (super.postInstall or "")
          + ''
            wrapProgram $out/bin/wechat --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
          '';
      })
    )
  ];
}
