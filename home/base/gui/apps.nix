{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs; [
    pkgs-stable.bitwarden-desktop
    zotero
  ];
}
