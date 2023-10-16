{ config, pkgs, ... }:

{
  # environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    oh-my-zsh = {
      enable = true;
      plugins = [ "z" ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
    shellAliases = {
      ll = "ls -l";
      la = "ls -al";
      ra = "ranger";
      use = "nix-shell -p";
      more = "less";
      g = "git";
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  xdg.configFile.".config/starship.toml".source = ./starship.toml;

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-b";
    terminal = "screen-256color";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    tmux.shellIntegrationOptions = [
      "--height 40%"
      "--border"
    ];
    defaultOptions = [
      "--height 80%"
      "--border"
    ];
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    neofetch
    ranger
    highlight
    bottom
  ];
}
