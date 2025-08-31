{
  pkgs,
  nur-pkgs-mslxl,
  config,
  ...
}: let
  shellAliases = {
    g = "git";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
  localBin = "${config.home.homeDirectory}/.local/bin";
  goBin = "${config.home.homeDirectory}/go/bin";
  rustBin = "${config.home.homeDirectory}/.cargo/bin";
  npmBin = "${config.home.homeDirectory}/.npm/bin";
in {
  home.shellAliases = shellAliases;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}:${npmBin}"
    '';
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
    initContent = ''
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}:${npmBin}"
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
