{
  pkgs,
  nur-pkgs,
  mylib,
  ...
}: {
  xdg.mimeApps.defaultApplications = (
    mylib.attrs.listToAttrs [
      "application/zip"
      "application/rar"
    ] (_: ["xarchiver.desktop"])
  );

  home.packages = with pkgs; [
    anki
    zenity
    trash-cli
    bat
    xarchiver
    telegram-desktop
    (wechat.overrideAttrs (super: {
      buildInputs = [pkgs.makeWrapper];

      postInstall =
        (super.postInstall or "")
        + ''
          wrapProgram $out/bin/wechat --set GTK_IM_MODULE fcitx --set QT_IM_MODULE fcitx
        '';
    }))
    readest
    calibre
  ];
}
