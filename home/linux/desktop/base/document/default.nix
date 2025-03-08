{
  pkgs,
  myutils,
  ...
}: {
  xdg.mimeApps.defaultApplications =
    {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["wps-office-wps.desktop"];

      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["wps-office-et.desktop"];
      "text/csv" = ["wps-office-et.desktop"];
    }
    // (myutils.attrs.listToAttrs [
      "application/pdf"
    ] (_: ["org.kde.okular.desktop"]))
    // (myutils.attrs.listToAttrs [
      "application/epub+zip"
      "application/vnd.comicbook+zip"
      "application/vnd.comicbook-rar"
    ] (_: ["koreader.desktop"]))
    ;

  home.packages = with pkgs; [
    kdePackages.okular
    koreader
    wpsoffice
  ];
}
