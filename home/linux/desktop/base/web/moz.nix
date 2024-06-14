{
  pkgs,
  myutils,
  ...
}: {
  xdg.mimeApps.defaultApplications =
    (myutils.attrs.listToAttrs [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/chrome"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ] (_: ["firefox.desktop"]))
    // (myutils.attrs.listToAttrs [
      "application/x-extension-rss=userapp"
      "application/rss+xml"
      "x-scheme-handler/feed"
      "x-scheme-handler/mid"
      "message/rfc822"
      "x-scheme-handler/mailto"
    ] (_: ["thunderbird.deskto"]));
  home.packages = with pkgs; [
    firefox
    thunderbird
    tor-browser
  ];
}
