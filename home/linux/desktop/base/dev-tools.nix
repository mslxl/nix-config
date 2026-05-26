{pkgs, ...}: {
  home.packages = with pkgs; [
    # cherry-studio
    codex
    claude-code

    synology-drive-client

    android-tools
  ];
}
