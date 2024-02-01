{pkgs, ...}:
{
  home.packages = with pkgs; [
    vivaldi
    typora
  ];
}
