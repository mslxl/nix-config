{
  config,
  lib,
  pkgs,
  username,
  ...
} @ args: rec {
  nixpkgs = {
    overlays = import ../overlays args;
    config.allowUnfree = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAWzzDW+0ytfjSytMcESuf1CFiuRCnOBlNpw65wtsyk/o1DajVIWdwI4sGLOzk+oNncqJPiQQ7v5a43mjJJP9XFCa9ohiRgTIoHtiPllA+4Kqm6dson+Q0skvq9DV62Sv9gKaGAhmKyxTvxqIq71BGwzKiMO8jFuuD2+J+FqA4Bvkb/ygwWersdc5V7fZdid20iop7Zk+GV+G1+qRvqHlTAQDu8kcTlbqJri9Zd8/Xf1RjxMwfsyBKZH9uUjKGCJD7oGRlYggd+tZ1TfJ/FYcEi23jaYHgtmeWkmVs1ro69vtlXVm5+WGQ77RJrZeSVxMKQhYuQkpBsCeK+1hHlKix7VPG6iKyR2X1zbrqlonkN2TH9fr+8vCdDHdNS8n8yMi5qk9gKphB89ashPAa7LJdkXB2g6doYYB1Z8KTiD1/jsLglWIZwywRV+kSeUQT1L9zrskTysmcxXRhnHpygpQMuC4wxVhTdzroSkhep0V2Ap64mxd8eIZ4GQn3jaVTJ7M= i@mslxl.com"
    ];
  };

  environment.pathsToLink = ["/share/zsh"]; # get completion for system packages in zsh

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Asia/Shanghai";
  environment.variables.TZ = time.timeZone;

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
    gnumake
    connect
    htop

    zip
    xz
    unzip
    p7zip

    neovim

    curl
    wget
  ];
  environment.variables.EDITOR = "emacs -nw";
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

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
