# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  hostName = "mslxl-xiaoxinpro16-2021";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./tlp.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 15;
      useOSProber = false;
      extraEntries = ''
        menuentry "Microsoft Windows 11" --class windows {
          search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
          chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      theme = pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.2";
        src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.2";
          hash = "sha256-U5QfwXn4WyCXvv6A/CYv9IkR/uDx4xfdSgbXDl5bp9M=";
        };
        installPhase = ''
          mkdir -p $out
          tar xvf themes/nixos.tar -C $out
        '';
      };
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.supportedFilesystems = ["ntfs"];

  boot.kernelParams = [
    # fix touchpad not work
    # see https://discourse.nixos.org/t/touchpad-click-not-working/12276
    "psmouse.synaptics_intertouch=0"

    # fix black screen when exit session
    # see https://nixos.wiki/wiki/Nvidia#Graphical_Corruption_and_System_Crashes_on_Suspend.2FResume
    # "module_blacklist=amdgpu"
  ];

  time.hardwareClockInLocalTime = true;

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
  ];

  powerManagement.enable = true;
  services.logind = {
    lidSwitchExternalPower = "lock";
    lidSwitch = "suspend-then-hibernate";
  };
  services.thermald.enable = true;

  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
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
      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:5:0:0";
    };
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  # virtualisation.docker.enableNvidia = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.v2raya.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  nix.settings.substituters = ["https://mirror.sjtu.edu.cn/nix-channels/store"];

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
