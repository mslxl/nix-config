{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../server
    ./office
    ./gtk.nix

    ./mpv.nix
    ./vivaldi.nix
    ./kdeconnect.nix
    ./zathura.nix
  ];

}
