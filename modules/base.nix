{
  config,
  lib,
  pkgs,
  username,
  ...
} @args: {
  nixpkgs.overlays = import ../overlays args;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    uid = 1000;
    shell = pkgs.zsh;
  };
  environment.pathsToLink = ["/share/zsh"]; # get completion for system packages in zsh

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Asia/Shanghai";

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

    neovim

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
