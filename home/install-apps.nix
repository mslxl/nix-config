{ pkgs, username, lib, ... }: {
  imports = [
    ./prog/ime
    ./prog/jetbrains-ide
    ./prog/media
    ./prog/social
    ./prog/typora
    ./prog/anki.nix
    ./prog/vscode.nix
    ./prog/calibre.nix
    ./prog/minecraft.nix
  ];

  home.packages = [
    pkgs.moc
    pkgs.obsidian
    pkgs.olive-editor
  ];
}
