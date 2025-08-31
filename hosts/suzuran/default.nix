# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  username,
  myutils,
  ...
}:
let
  hostName = "suzuran";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./tlp.nix
    ./host.nix
    ./nvidia.nix
    ./gaming.nix
  ];

  time.hardwareClockInLocalTime = true;
  users.users.${username}.extraGroups = [ "networkmanager" ];

  networking = {
    inherit hostName;
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall.enable = false;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
  };

  environment.systemPackages = with pkgs; [
    lshw
    glxinfo
    cifs-utils
  ];

  # fileSystems = let
  #   bindDir = name: {
  #     name = "/mnt/kamoi/${name}";
  #     value = {
  #       device = "//192.168.1.128/${name}";
  #       fsType = "cifs";
  #       options = let
  #         automount_opts = "nobrl,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
  #       in ["${automount_opts},credentials=${config.age.secrets."samba-kamoi".path},uid=1000,gid=100"];
  #     };
  #   };
  # in
  #   builtins.listToAttrs (builtins.map bindDir ["secret" "public" "home" "docker" "music" "calibre" "backup"]);

  powerManagement.enable = true;
  services.logind.settings = {
    Login = {
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitch = "suspend-then-hibernate";
    };
  };
  services.thermald.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
