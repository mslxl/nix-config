{ pkgs, username, lib, ... }: {
  imports = [
    ./prog/ime
    ./prog/jetbrains-ide
    ./prog/media
    ./prog/anki.nix
    ./prog/social.nix
    ./prog/vscode.nix
  ];

}
