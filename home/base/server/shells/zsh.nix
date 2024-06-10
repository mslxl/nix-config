{pkgs, ...}: {
  home.packages = with pkgs; [
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
    enableVteIntegration = true;
    shellAliases = {
      g = "git";
    };
    localVariables = {
    };
    initExtra = ''
      if [[ $(tty) == *"pts"* ]] {
         ${pkgs.fastfetch}/bin/fastfetch --cpu-temp --gpu-temp --battery-temp
      }
    '';
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "safe-paste"
        "git"
        "extract"
        "vi-mode"
      ];
    };
  };
}
