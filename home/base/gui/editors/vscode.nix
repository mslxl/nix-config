{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.vscode
      else pkgs.vscode.fhs;
  };
}
