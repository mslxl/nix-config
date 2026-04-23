{...}: {
  targets.darwin = {
    # Keep the existing home.stateVersion for unrelated behavior, but opt in to
    # the newer app-copying activation so macOS sees real app bundles.
    copyApps.enable = true;
    linkApps.enable = false;
  };
}
