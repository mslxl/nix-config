{pkgs, ...}: {
  home.packages = with pkgs; [
    pfetch
    git
    tokei
  ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    enableCompletion = true;
    defaultKeymap = "viins";
    shellAliases = {
      g = "git";
    };
    initExtra = ''
      if [[ $(tty) == *"pts"* ]] {
         pfetch
      }
    '';
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "safe-paste"
        "git"
        "extract"
      ];
    };
  };
}
