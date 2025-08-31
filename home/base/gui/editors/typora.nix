{pkgs, ...}: {
  home.packages = with pkgs; [
    typora
  ];
  xdg.mimeApps.defaultApplications = {
    "text/markdown" = ["typora.desktop"];
  };
}
