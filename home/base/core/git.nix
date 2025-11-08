{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  home.packages = with pkgs; [
    commitizen
  ];
  programs.lazygit.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
    hosts = {
      "github.com" = {
        "users" = {
          "mslxl" = null;
        };
        "user" = "mslxl";
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = myvars.username;
        email = myvars.useremail;
        signingkey = myvars.useremail;
      };
      alias = {
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
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
    ];
  };
  # A syntax-highlighting pager for git, diff, grep, and blame output
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      diff-so-fancy = true;
      line-numbers = true;
      true-color = "always";
      # features => named groups of settings, used to keep related settings organized
      # features = "";
    };
  };
}
