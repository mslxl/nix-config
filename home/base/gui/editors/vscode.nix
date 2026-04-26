{pkgs, ...}: {
  # Install VS Code without letting Home Manager manage its settings,
  # extensions, keybindings, or profiles.
  home.packages = [
    (
      if pkgs.stdenv.isDarwin
      then pkgs.vscode
      else pkgs.vscode.fhs
    )
  ];
}
