{
  config,
  pkgs-unstable,
  ...
}: let
  nu_scripts = pkgs-unstable.nu_scripts.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace modules/kubernetes/{env,utils}.nu \
          --replace-fail "str downcase" "str lowercase"
      '';
  });
in {
  programs.nushell = {
    # load the alias file for work
    # the file must exist, otherwise nushell will complain about it!
    #
    # currently, nushell does not support conditional sourcing of files
    # https://github.com/nushell/nushell/issues/8214
    extraConfig = ''
      # Directories in this constant are searched by the
      # `use` and `source` commands.
      const NU_LIB_DIRS = $NU_LIB_DIRS ++ ['${nu_scripts}/share/nu_scripts']

      # completion
      use custom-completions/cargo/cargo-completions.nu *
      use custom-completions/curl/curl-completions.nu *
      use custom-completions/git/git-completions.nu *
      use custom-completions/glow/glow-completions.nu *
      use custom-completions/just/just-completions.nu *
      use custom-completions/make/make-completions.nu *
      use custom-completions/man/man-completions.nu *
      use custom-completions/nix/nix-completions.nu *
      use custom-completions/ssh/ssh-completions.nu *
      use custom-completions/tar/tar-completions.nu *
      use custom-completions/tcpdump/tcpdump-completions.nu *
      use custom-completions/zellij/zellij-completions.nu *
      # use custom-completions/zoxide/zoxide-completions.nu *

      # alias
      # use aliases/git/git-aliases.nu *
      use aliases/eza/eza-aliases.nu *
      use aliases/bat/bat-aliases.nu *

      # modules
      # Keep `parse` namespaced as `argx parse`; importing every export would
      # shadow Nushell's built-in `parse` command used by fzf integration.
      use modules/argx
      use modules/lg *
      use modules/kubernetes *
    '';
  };
}
