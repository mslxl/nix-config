{pkgs, ...}: {
  home.packages = with pkgs;
    [
      mitmproxy # http/https proxy tool
      wireshark # network analyzer

      # # AI cli tools
      # k8sgpt
      # kubectl-ai # an ai helper opensourced by google
      qrcp
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia # REST client
    ]);
}
