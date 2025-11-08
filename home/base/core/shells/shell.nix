{
  pkgs,
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

      
    '' ++ (lib.optionalString pkgs.stdenv.isDarwin ''
    # Useful support for interacting with Terminal.app or other terminal programs
    [ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"
    '');
    oh-my-zsh = {
      enable = true;
      plugins = [
        "safe-paste"
        "extract"
        "vi-mode"
      ];
    };
  };

  # NOTE: only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;

  # NOTE: nushell will be launched in bash, so it can inherit all the eenvironment variables.
  programs.nushell = {
    enable = true;
    # package = pkgs-unstable.nushell;
    configFile.source = ./config.nu;
    inherit shellAliases;
  };
}
