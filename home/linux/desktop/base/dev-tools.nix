{pkgs, ...}: {
  home.packages = with pkgs; [
    cherry-studio
    synology-drive-client

    android-tools
  ];
}
