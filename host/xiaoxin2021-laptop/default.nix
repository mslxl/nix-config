# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }@args:

{
  imports =
    [
      # Include the results of the hardware scan.
      ../../modules/core-desktop.nix
      ./hardware.nix
    ];


  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
  };

  # Enable networking
  networking = {
    hostName = "mslxl-laptop"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://192.168.1.162:10809";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  system.stateVersion = "23.11";
}


