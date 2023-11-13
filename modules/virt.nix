{pkgs, username, dconf,...}: {
    users.users."${username}".extraGroups = [ "libvirtd" "kvm" ];
    virtualisation = {
        libvirtd = {
            enable = true;
            qemu = {
                swtpm.enable = true;
                ovmf.enable = true;
                ovmf.packages = [ pkgs.OVMFFull.fd ];
                runAsRoot = false;
            };
        };
        spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
    programs.dconf.enable = true; # virt-manager requires dconf to remember settings
    environment.systemPackages = with pkgs; [ 
        virt-manager
        virt-viewer
        spice spice-gtk
        spice-protocol
        win-virtio
        win-spice
        libguestfs
        bridge-utils
        qemu_kvm
        gnome.adwaita-icon-theme
    ];
    boot.kernelModules = ["kvm-amd" "kvm-intel" "nf_nat_ftp" ];

    boot.kernel.sysctl= {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv4.conf.default.forwarding" = true;
    };

    # virtualisation.virtualbox.host = {
    #     enable = true;
    #     enableExtensionPack = true;
    # };
    # users.extraGroups.vboxusers.members = [ "${username}" ];
}