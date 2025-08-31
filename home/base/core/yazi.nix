{
  pkgs,
  system,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    # "x-scheme-handler/file" = ["yazi.desktop"];
    "inode/directory" = ["yazi.desktop"];
  };
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # keymap = {
    #   manager.keymap = [
    #     {
    #       run = "shell \"qrcp send $@\" --block";
    #       on = ["c q s"];
    #     }
    #   ];
    # };
    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
