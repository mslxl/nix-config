{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    trash-cli
    wpsoffice
  ];
}
