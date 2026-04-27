{
  agenix,
  lib,
  myvars,
  pkgs,
  secrets,
  ...
}: {
  environment.systemPackages = [
    agenix.packages.${pkgs.system}.default
  ];

  age.identityPaths = lib.mkDefault [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets =
    {
      "nix-access-token" = {
        file = "${secrets}/nix-access-token.age";
        mode = "0440";
        owner = myvars.username;
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      "samba-kamoi" = {
        file = "${secrets}/samba-kamoi.age";
        mode = "0500";
        owner = "root";
      };
    };
}
