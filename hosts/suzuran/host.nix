{
  pkgs,
  wallpapers,
  username,
  ...
}: {
  modules.desktop = {
    wayland.enable = true;
    type = "niri";
  };

  fileSystems."/home/${username}/nolebase" = {
    device = "/dev/nvme0n1p5";
    fsType = "ntfs";
    options = [
      "users"
      "exec"
    ];
  };
  fileSystems."/run/media/${username}/source" = {
    device = "/dev/nvme0n1p4";
    fsType = "ntfs";
    options = [
      "users"
      "exec"
    ];
  };

  nix.settings = {
    max-jobs = 12; # leave 4 CPU for other work, which would make computer available when rebuild
    cores = 12;
  };
}
