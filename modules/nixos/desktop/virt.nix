{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  services.flatpak.enable = true;
  virtualisation = {
    docker = {
      enable = false;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        "features" = {
          "containerd-snapshotter" = true;
        };
      };
      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;
    };
    waydroid.enable = false;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # Periodically prune Podman resources
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all"];
      };
    };
    oci-containers = {
      backend = "podman";
    };
    # libvirtd = {
    #   enable = false;
    #   # hanging this option to false may cause file permission issues for existing guests.
    #   # To fix these, manually change ownership of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
    #   qemu = {
    #     runAsRoot = true;
    #     swtpm.enable = true;
    #     ovmf.enable = true;
    #     ovmf.packages = [pkgs.OVMFFull.fd];
    #   };
    # };
    # spiceUSBRedirection.enable = true;
    # lxd.enable = true;
  };

  services.spice-vdagentd.enable = false;
  environment.systemPackages = with pkgs; [
    # docker-compose

    # # Need to add [File (in the menu bar) -> Add connection] when start for the first time
    # virt-manager
    # virt-viewer

    # # QEMU/KVM(HostCpuOnly), provides:
    # #   qemu-storage-daemon qemu-edid qemu-ga
    # #   qemu-pr-helper qemu-nbd elf2dmp qemu-img qemu-io
    # #   qemu-kvm qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386
    # qemu_kvm

    # # Install QEMU(other architectures), provides:
    # #   ......
    # #   qemu-loongarch64 qemu-system-loongarch64
    # #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    # #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    # #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    # #   ......
    # qemu

    # virtiofsd
    # spice
    # spice-gtk
    # spice-protocol
    # win-virtio
    # win-spice
  ];
}
