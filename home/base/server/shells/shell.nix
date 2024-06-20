{
  pkgs,
  scripts,
  ...
}: let
  shellAliases = {
    g = "git";
  };
in {
  home.packages = with pkgs; [
    git
    tokei
    just
    scripts.packages.${pkgs.system}.default
  ];

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
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "safe-paste"
        "extract"
        "vi-mode"
      ];
    };
  };
}
