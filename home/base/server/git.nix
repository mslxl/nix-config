{ config, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName = "mslxl";
    userEmail = "i@mslxl.com";

    aliases = {
      cm = "commit";
      ck = "checkout";
      br = "branch";
      st = "status";
      lg = "log";
      lz = "!lazygit";
    };

    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      http = {
        proxy = "http://127.0.0.1:20171";
      };
      https = {
        proxy = "http://127.0.0.1:20171";
      };
      user = {
        signingkey = "i@mslxl.com";
      };
      core = {
        sshCommand = "ssh -o ProxyCommand=\"connect -S 127.0.0.1:20170 %h %p\"";
      };
      init = {
        defaultBranch = "main";
      };
      commit = {
        gpgsign = true;
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
  programs.git.lfs.enable = true;
  home.packages = with pkgs; [
    # cz-cli
    commitizen
  ];
}
