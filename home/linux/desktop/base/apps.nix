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

  home.packages =
    (with pkgs; [
      anki
      zenity
      trash-cli
      bat
      xarchiver
      readest
      calibre
    ]);
}
