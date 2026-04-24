{pkgs, ...}: {
  targets.darwin = {
    # Keep the existing home.stateVersion for unrelated behavior, but opt in to
    # the newer app-copying activation so macOS sees real app bundles.
    copyApps.enable = true;
    linkApps.enable = false;
  };

  home.packages = with pkgs; [
    chatgpt
    drawio
    iina
    keka
    orbstack
    stats
  ];
}
