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
      yt-dlp

      nix-tree
      nix-melt
      bottom
      difftastic
    ])
    ++ [
      (pkgs.callPackage ../../../pkgs/trzsz-ssh.nix {})
      (pkgs.callPackage ../../../pkgs/trzsz-go.nix {})
    ];

  home.shell = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.eza = {
    enable = true;
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
    settings = {
      time = {
        disabled = false;
      };
    };
  };
}
