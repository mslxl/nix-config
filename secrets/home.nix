{
  agenix,
  config,
  lib,
  pkgs,
  secrets,
  ...
}: {
  home.packages = [
    agenix.packages.${pkgs.system}.default
  ];

  age.identityPaths = lib.mkDefault [
    "/etc/ssh/ssh_host_ed25519_key"
    "${config.home.homeDirectory}/.ssh/id_ed25519"
  ];

  age.secrets."nix-access-token" = {
    file = "${secrets}/nix-access-token.age";
  };
}
