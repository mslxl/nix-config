{
  pkgs,
  system,
  yazi,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    package = yazi.packages.${system}.default;
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
