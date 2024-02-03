{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    typora
    trash-cli
    wpsoffice
  ];
}
