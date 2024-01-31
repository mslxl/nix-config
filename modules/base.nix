{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Asian/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  environment.systemPackages = with pkgs; [
    tree
    git

    zip
    xz
    unzip
    p7zip

    gcc
    cmake
    libtool
    gnumake
    neovim
    emacs

    curl
    wget
  ];
  environment.variables.EDITOR = "nvim";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;
}
