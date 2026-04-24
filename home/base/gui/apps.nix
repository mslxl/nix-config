{pkgs, ...}: {
  home.packages = with pkgs; [
    anki
    bitwarden-desktop
    zotero
  ];
}
