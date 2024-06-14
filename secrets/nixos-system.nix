{
  agenix,
  secrets,
  pkgs,
  username,
  ...
}: {
  imports = [
    agenix.nixosModules.default
  ];
  environment.systemPackages = [agenix.packages.${pkgs.system}.default];

  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  age.secrets = {
    "samba-kamoi" = {
      file = "${secrets}/samba-kamoi.age";
      mode = "0500";
      owner = "root";
    };

    "nix-access-token" = {
      file = "${secrets}/nix-access-token.age";
      mode = "0440";
      owner = username;
    };
  };
}
