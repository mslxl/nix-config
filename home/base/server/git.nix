{
  config,
  lib,
  pkgs,
  username,
  useremail,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
    commitizen
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = username;
    userEmail = useremail;
    aliases = {
      st = "status";
      lg = "log --graph --decorate --oneline";
      cm = "!cz commit";
      lz = "!lazygit";
      ck = "checkout";
      br = "branch";
      fomo = "!git fetch origin main && git rebase origin/main";
      # 删除最近的提交，保留文件修改
      undo = "reset --soft HEAD^";
      # 删除最近一个提交，不保留文件
      cancel = "reset --hard HEAD^";
      # 提交完了，发现还需要一点小修改，不想新建一个提交
      onemore = "commit -a --amend --no-edit";
    };

    ignores = [
      "*~"
      "*.swp"
    ];

    extraConfig = {
      user = {
        signingkey = useremail;
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
}
