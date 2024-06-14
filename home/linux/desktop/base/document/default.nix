{
  pkgs,
  myutils,
  ...
}: {
  xdg.mimeApps.defaultApplications =
    {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["wps-office-wps.desktop"];
      "text/csv" = ["wps-office-et.desktop"];
    }
    // (myutils.attrs.listToAttrs [
      "application/pdf"
      "application/epub+zip"
      "application/vnd.comicbook+zip"
      "application/vnd.comicbook-rar"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ] (_: ["org.kde.okular.desktop"]));

  home.packages = with pkgs; [
    okular
    wpsoffice
  ];
}
