{
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
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
