{
  pkgs,
  ...
}:
{

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.pathsToLink = [ "/share/zsh" ]; # get completion for system packages in zsh

  environment.systemPackages = with pkgs; [
    gnumake
  ];
}
