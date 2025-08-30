{
  pkgs,
  nur-pkgs-mslxl,
  ...
}: let
  shellAliases = {
    g = "git";
  };
in {
  home.packages =
    (with pkgs; [
      git
      lice
      tokei
      just
    ])
    ++ (with nur-pkgs-mslxl; [
      trzsz-ssh
      trzsz-go
    ]);

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
    initContent = ''
      if [[ $(tty) == *"pts"* ]] {
         ${pkgs.fastfetch}/bin/fastfetch
      }
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
