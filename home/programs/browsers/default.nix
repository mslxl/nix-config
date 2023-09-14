{ config, pkgs, home-manager, ... }:

let
  defaultBrowser = "vivaldi-stable.desktop";
in
{
  imports = [
    ./vivaldi.nix
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications =

      {
        "text/html" = defaultBrowser;
        "x-scheme-handler/http" = defaultBrowser;
        "x-scheme-handler/https" = defaultBrowser;
        "x-scheme-handler/about" = defaultBrowser;
        "x-scheme-handler/unknown" = defaultBrowser;
      };
  };
}
