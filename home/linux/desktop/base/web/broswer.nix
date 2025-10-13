{pkgs,...}:{
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "chejfhdknideagdnddjpgamkchefjhoi";} # VertiTab
      {id = "gfbliohnnapiefjpjlpjnehglfpaknnc";} # Surfingkey
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";} # Grammarly
      {id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh";} # Immersive Translate
      {id = "mgpdnhlllbpncjpgokgfogidhoegebod";} # Photo Show
      {id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # Tampermonkey
    ];
  };
}