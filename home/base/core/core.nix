{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      fzf
      fd
      (ripgrep.override {withPCRE2 = true;})
      ast-grep
      sad
      gping
      hyperfine
      gdu
      du-dust
      duf
      gnupg
      gnumake
      just

      nix-tree
      nix-melt
      bottom
      difftastic
    ])
    ++ [
      (pkgs.callPackage ../../../pkgs/trzsz-ssh.nix {})
      (pkgs.callPackage ../../../pkgs/trzsz-go.nix {})
    ];
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      simplified_ui = true;
      # default_layout = "compact";
    };
  };
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = false;
        auto_update_interval_hours = 720;
      };
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      time = {
        disabled = false;
      };
    };
  };
}
