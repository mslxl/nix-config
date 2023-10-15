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
  ];

}
