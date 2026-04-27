{config,lib, ...}: {
  ###################################################################################
  #
  #  Core configuration for nix-darwin
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  # History Issues:
  #  1. Fixed by replace the determined nix-installer by the official one:
  #     https://github.com/LnL7/nix-darwin/issues/149#issuecomment-1741720259
  #
  ###################################################################################

  # Determinate uses its own daemon to manage the Nix installation that
  # conflicts with nix-darwin's native Nix management. so we should disable this option.
  nix.enable = true;

  # Disable auto-optimise-store because of this issue:
  #   https://github.com/NixOS/nix/issues/7273
  # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
  nix.settings.auto-optimise-store = false;

  nix.gc = {
    automatic = lib.mkDefault true;
    interval = lib.mkDefault [{
      Hour = 0;
      Minute = 0;
      Weekday = 7;
    }]; 
    options = lib.mkDefault "--delete-older-than 7d";
  };

  system.stateVersion = 5;

  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-token.path}
  '';
}
