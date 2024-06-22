{
  pkgs,
  myutils,
  ...
}: let
  patchIcon = pkgs.lib.concatStringsSep "\n" (
    builtins.map (den: ''
      TARGET_${den}=$out/share/icons/hicolor/${den}x${den}/apps/
      # [ -f "$TARGET_${den}/firefox.png" ] && rm "$TARGET_${den}/firefox.png"
      convert ${./kitsune.png} -resize ${den}x${den} "$TARGET_${den}/kitsune.png"

    '') [
      "16"
      "32"
      "48"
      "64"
      "128"
    ]
  ) + ''sed -i "s@Icon=firefox@Icon=kitsune@g" $out/share/applications/*.desktop'';

  firefox-kitsune = builtins.trace patchIcon (
    pkgs.firefox.overrideAttrs (super: {
      nativeBuildInputs =
        super.nativeBuildInputs
        ++ [
          pkgs.imagemagick
        ];
      buildCommand =
        super.buildCommand
        + patchIcon;
    })
  );
in {
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

  home.packages = [
    firefox-kitsune
    pkgs.thunderbird
    pkgs.tor-browser
  ];
}
