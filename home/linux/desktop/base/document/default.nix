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
      "application/epub+zip"
      "application/vnd.comicbook+zip"
      "application/vnd.comicbook-rar"
    ] (_: ["org.kde.okular.desktop"]));

  home.packages = with pkgs; [
    okular
    wpsoffice
  ];
}
