{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      font-family = "Maple Mono NF";
      font-size = 12;
    };
  };
}
