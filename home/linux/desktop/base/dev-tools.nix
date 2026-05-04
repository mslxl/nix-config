{pkgs, ...}: {
  home.packages = with pkgs; [
    # cherry-studio
    codex
    synology-drive-client

    android-tools
  ];
}
