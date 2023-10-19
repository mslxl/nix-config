{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../server
    ./office
    ./gtk.nix

    ./vivaldi.nix
    ./kdeconnect.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    mpv
    bitwarden
  ];

}
