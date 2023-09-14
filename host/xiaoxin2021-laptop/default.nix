# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{


  imports =
    [
      # Include the results of the hardware scan.
      ../../modules/system.nix
      ./hardware.nix
    ];

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };


  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = null;
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub = {
    device = "nodev";
    default = "1";
    efiSupport = true;

    useOSProber = false;

    extraEntries = ''
      menuentry "Microsoft Windows 11" --class windows {
        search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
        chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };

  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes";
    version = "3.2";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.2";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    installPhase = "cp -r customize/nixos $out";
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 16;
    }
  ];

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "mslxl-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;



}


