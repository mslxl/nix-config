{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  home.packages = with pkgs; [
    code-cursor
  ];
}
