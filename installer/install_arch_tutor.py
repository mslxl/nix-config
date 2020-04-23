#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

# Tools


def hr():
    print("---------------------------")


def br(line=1):
    for i in range(0, line):
        print()


def cls():
    os.system("clear")


def userEdit(filename):
    os.system("vim "+filename)


def testNetwork() -> bool:
    ip = "114.114.114.114"
    print("Test network by ping " + ip)
    result = os.system("ping -c 5 -W 1 " + ip)
    return not bool(result)


def exec(cmd:str) -> int:
    return os.system(cmd)


def chrootExec(cmd:str) -> int:
    return os.system("arch-chroot /mnt " + cmd)

# Steps


def stepInfo():
    hr()
    print("Wellcome to install Arch Linux")
    print("Offical doc: https://wiki.archlinux.org/index.php/Installation_guide")
    print("Anyway, install Arch linux could not with it")
    print("You can use your phone or w3m to expoler it.")
    print("Press <Enter> to continue...")
    hr()
    input()
    br(2)


def subSetpConnectWifi():
    print("Warning: this script does not test due to I have not got wireless network card")
    hr()
    print("Network devices:")
    exec("ip link")
    hr()
    device = input("Which one is the device you want:")
    print("Set device %s on" % device)
    exec("ip link set %s up" % device)
    print("Wifi SSID list:")
    exec('iwlist %s scan | grep ESSID' % device)
    wifiName = input("SSID: ")
    wifiPwd = input("Password: ")
    print("Connecting...")
    exec("wpa_passphrase %s %s > /tmp/wpa_pass.conf" % (wifiName, wifiPwd))
    exec("wpa_supplicant -c /tmp/wpa_pass.conf -i %s &" % device)
    exec("dhcpcd")


def stepConnectInternet():
    while not testNetwork():
        hr()
        print("You are disconnected!")
        print("If you want to use wifi to connect internet, ", end='')
        print("you can type 'zsh' to config manually, or press <Enter> to use this script config.")
        if input() == "zsh":
            print("Maybe you can use 'wifi-menu' to connect internet.")
            print("Type 'exit' to continue install")
            hr()
            exec("zsh")
        else:
            subSetpConnectWifi()


def stepChooseMirror():
    print("You can switch your pacman mirror to get faster installtion.")
    print("Move the fastest mirror server to the top of the file.")
    print("Sometimes, there are lots of server in your location.")
    print("Press <Enter> to open mirrorlist or 'skip' to skip this step:")
    if input() == "skip":
        return
    userEdit("/etc/pacman.d/mirrorlist")
    exec("pacman -Syy")


def stepConfigPacman():
    print("Now, you have a chance to config pacman")
    print("It is recommend to enable COLOR by remove comment before COLOR tag.")
    print("Press <Enter> to open config file or 'skip' to skip this step:")
    if input() == "skip":
        return
    userEdit("/etc/pacman.conf")


def stepSetTime():
    print("Switch to local time and sysnc")
    exec("timedatectl set-local-rtc true")
    exec("timedatectl set-ntp true")


def stepPartDisk():
    hr()
    help = """
It is time to part your disk!
You should better DO NOT SKIP this step, or your system may can not boot.
These text will be saved as /tmp/partition.txt
After partition ,type 'exit' to continue install
Help:
    fdisk -l                : List all disk
    fdisk /dev/<sd.>        : Enter fdisk repl
        Tips:
            1. Create GPT partition table
            2. Create Boot partition (recommend 512M)
            3. Create Swap partition (recommend make it as same as your RAM)
            4. Create other partition
            5. Do not forget to write parition table

    mkfs.fat -F32 /dev/<BOOT_PARTITION>     : Boot partition must be FAT32
    mkfs.<fs> /dev/<OTHER_PARTITION>        : Choose your own file system
    mkswap /dev/<SWAP_PARTITION>
    swapon /dev/<SWAP_PARTITION>            : Open swap
    """
    with open('/tmp/partition.txt', 'w') as f:
        f.write(help)
    print(help)
    exec("zsh")


def stepMountPartition():
    help = """
        Now, it is time to mount your partition.
        You should mount your partition on /mnt
        After mount, type 'exit' to continue.
        Maybe you will use:
            fdisk -l
            mount
    """
    print(help)
    hr()
    exec("zsh")


def stepInstallBase():
    print("Start install now?")
    print("Press <Enter> to start, or <C-c> to give up.")
    input()
    cls()
    print("Start install...")
    exec("pacstrap /mnt base linux linux-firmware")


def stepGenFstab():
    print("Generate fstab file...")
    exec("genfstab -U /mnt >> /mnt/etc/fstab")


def stepChroot():
    print("You will chroot into the system you installed")
    print("Press <Enter> to continue or type 'skip' to skip")
    if input() == "skip":
        return
    help = """
    Tips:
        Continue install:
            exit
        Change timezone example:
            ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        Sysnc time:
            hwclock --systohc
        Localization file:
            /etc/locale.gen
        Generate localization:
            locale-gen
        Config localization file:
            e.g. Add 'LANG=en_US.UTF8' to
            /etc/locale.conf
    You do not need to install GRUB, it will be installed next.
    These help will save as /mnt/chroot_help.txt, i.e. you can see it by cat /chroot_help.txt
    """
    print(help)
    with open('/mnt/chroot_help.txt', 'w') as f:
        f.write(help)
    exec("arch-chroot /mnt")
    os.remove('/mnt/chroot_help.txt')


def stepSimpleSettings():
    hr()
    print("Simple settings")
    hr()
    hostname = input("Hostname: ")
    with open('/mnt/etc/hostname', 'w') as f:
        f.write(hostname)

    print("Write host file...")
    host = """
    127.0.0.1           localhost
    ::1                 localhost"""
    with open('/mnt/etc/host', 'w') as f:
        f.write(host)
    print("Setup admin password")
    chrootExec("passwd")


def stepInstallGrub():
    print("Choose your CPU")
    ucode = ""
    print("-1 : intel")
    print(" 0 : do not install ucode")
    print("other: amd")
    cmd = input("Num: ")
    if cmd == "-1":
        ucode = "intel-ucode"
    elif cmd == "0":
        ucode = ""
    else:
        ucode = "amd-ucode"
        print("AMD YES!")
    chrootExec("pacman -S grub efibootmgr os-prober " + ucode)
    if not os.path.exists('/mnt/boot/grub'):
        os.makedirs("/mnt/boot/grub")
    chrootExec("grub-mkconfig > /mnt/boot/grub/grub.cfg")
    retry = True
    while retry:
        print("Grub install target: [x86_64-efi/i386-pc]:")
        module = input("Your platfrom: ")
        retry = False
        if module == "x86_64-efi":
            chrootExec("grub-install --target=x86_64-efi --efi-directory=/boot")
        elif module == "i386-pc":
            disk = input("Your boot partition:")
            chrootExec("arch-chroot /mnt grub-install --target=i386-pc " + disk)
        else:
            retry = True


def stepAddUser():
    hr()
    print("Add user")
    hr()
    username = input("Username")
    chrootExec("useradd -m -G wheel " + username)
    chrootExec("passwd " + username)
    print("Now you should enable user group wheel to run any command.")
    print("The only thing you need to do is uncomment wheel statment.")
    print("You can find it by search '%wheel' easily.")
    print("Press <Enter> to edit sudo config")
    input()
    chrootExec("visudo")


def stepInstallExtra():
    hr()
    print("Install devel")
    chrootExec("pacman -S base-devel")
    chrootExec("pacman -S man vi")
    hr()
    print("Install Network package")
    hr()
    chrootExec("pacman -S wpa_supplicant dhcpcd networkmanager dhclient ")
    # NetworkManager GUI
    # os.system("arch-chroot /mnt pacman -S nm-connection-editor")
    chrootExec("systemctl enable NetworkManager")

# Running


steps = {}


def registerStep(step):
    i = len(steps.keys())
    steps[i] = step


def runStep(start=1):
    total = len(steps.keys())
    for i in range(start - 1, total):
        hr()
        step = steps[i]
        print("Step [%d/%d]: %s" % (i + 1, total, step.__name__))
        step()
        br()


if __name__ == "__main__":
    cls()
    reg = registerStep
    reg(stepInfo)
    reg(stepConnectInternet)
    reg(stepConfigPacman)
    reg(stepChooseMirror)
    reg(stepSetTime)
    reg(stepPartDisk)
    reg(stepMountPartition)
    reg(stepInstallBase)
    reg(stepGenFstab)
    reg(stepSimpleSettings)
    reg(stepChroot)
    reg(stepInstallGrub)
    reg(stepInstallExtra)
    reg(stepAddUser)
    startStep = 1
    if len(sys.argv) > 1:
        startStep = int(sys.argv[1])
    runStep(startStep)
    hr()
    print("Install finish.")
