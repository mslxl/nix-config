{ pkgs, username, lib, ... }: {
  imports = [
    ./prog/ime
    ./prog/jetbrains-ide
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
  # xdg-mime query filetype foo.pdf
  # xdg-mime query default application/pdf
  # fd evince.desktop /

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = ["feh.desktop"];
      "image/gif" = ["feh.desktop"];
      "image/png" = ["feh.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "wps-office-wps.desktop" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "wps-office-et.desktop" ];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "wps-office-wpp.desktop" ];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };
}
