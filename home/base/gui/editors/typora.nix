{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    typora
  ];

  xdg.mimeApps.defaultApplications = lib.mkIf (!pkgs.stdenv.isDarwin) {
    "text/markdown" = ["typora.desktop"];
  };
}
