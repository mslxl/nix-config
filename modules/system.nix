{ config, pkgs, ... }:
{
  services.v2raya.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mslxl = {
    isNormalUser = true;
    description = "mslxl";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "light" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";
  fonts = {
    enableDefaultPackages = false;

    packages = with pkgs; [
      material-design-icons
      font-awesome

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      jetbrains-mono

      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  programs.dconf.enable = true;

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];
  services.flatpak.enable = true;

  nix.settings.substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "delete-older-than 7d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.autoUpgrade = {
    enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.power-profiles-daemon = {
    enable = true;
  };
  security.polkit.enable = true;

  services = {
    dbus.packages = [ pkgs.gcr ];

    geoclue2.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      wireplumber.enable = true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
  virtualisation.docker.enable = true;
  # virtualisation.docker.enableNvidia = true;
  # services.dockerRegistry.extraConfig = {
  #   utsc = "http://mirrors.ustc.edu.cn/"
  # };
  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    xdg-user-dirs

    connect
    wget
    curl
    bottom

    zip
    xz
    unzip
    p7zip

    ripgrep
    fzf

    file
    which
    tree
    zstd
    openssl
    pkg-config

    lm_sensors
    docker-compose
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.direnv.enable = true;
}
