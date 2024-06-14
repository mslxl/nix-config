{pkgs, ...}: let
  shellAliases = {
    g = "git";
  };
in {
  home.packages = with pkgs; [
    git
    tokei
  ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = false;
    enableBashIntegration = false;
    settings = {
      time = {
        disabled = false;
      };
    };
  };
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
      }
    '';
    extraConfig = ''
      if (tty | str contains "pts") {
          ${pkgs.fastfetch}/bin/fastfetch --cpu-temp --gpu-temp --battery-temp
      }
    '';
    inherit shellAliases;
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
    inherit shellAliases;
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
