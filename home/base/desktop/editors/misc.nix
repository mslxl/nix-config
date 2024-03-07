{pkgs, ...}: {
  home.packages = with pkgs; [
    cpeditor
    typora
  ];
}
