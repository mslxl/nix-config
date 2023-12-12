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
      ./tlp.nix
    ];

  environment.systemPackages = with pkgs; [
    lshw
    dnsmasq
  ];


  services.logind = {
    lidSwitchExternalPower = "lock";
    lidSwitch = "suspend-then-hibernate";
  };
  # boot.initrd.kernelModules = [ "nvidia" ];
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" "modesetting"];
  # services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  hardware.cpu.amd.updateMicrocode = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    # nvidiaPersistenced = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      allowExternalGpu = true;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Make sure to use the correct Bus ID values for your system!
      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:5:0:0";
	  };
  };

  # Enable networking
  networking = {
    hostName = "mslxl-laptop"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
      dhcp = "dhcpcd";
    };
  };
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://192.168.1.162:10809";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  system.stateVersion = "23.11";
}


