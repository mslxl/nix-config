{ config, ... }:
{
  boot.kernelParams = [
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    "nvidia-drm.fbdev=1"

    # fix black screen when exit session
    # see https://nixos.wiki/wiki/Nvidia#Graphical_Corruption_and_System_Crashes_on_Suspend.2FResume
    # "module_blacklist=amdgpu"
  ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      allowExternalGpu = true;

      # Use this to save energy
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:5:0:0";
    };
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };
}
