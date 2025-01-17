{
  pkgs,
  system,
  ...
}: {

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/file" = ["yazi.desktop"];
    "inode/directory" = ["yazi.desktop"];
  };
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    # keymap = {
    #   manager.keymap = [
    #     {
    #       run = "shell \"qrcp send $@\" --block";
    #       on = ["c q s"];
    #     }
    #   ];
    # };
  };
}
