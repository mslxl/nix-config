{ nixpkgs, config, pkgs, ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPortRanges = [
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];
  #   allowedUDPPortRanges = [
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];
  # };
}
