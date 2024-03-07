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
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
