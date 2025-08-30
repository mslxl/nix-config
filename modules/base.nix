{
  config,
  lib,
  pkgs,
  nur,
  username,
  ...
} @ args: rec {
  home-manager.backupFileExtension = "backup";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    uid = 1000;
    shell = pkgs.zsh;
  };

  environment.pathsToLink = ["/share/zsh"]; # get completion for system packages in zsh

  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
}
