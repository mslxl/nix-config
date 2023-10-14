{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../server
    ./gtk.nix

    ./mpv.nix
    ./vivaldi.nix
    ./kdeconnect.nix
    ./terminal/foot.nix
  ];

}
