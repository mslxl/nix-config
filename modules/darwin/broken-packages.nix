{lib, ...}:
# ===================================================================
# Remove packages that are not well supported for the Darwin platform
# ===================================================================
let
  brokenPackages = [
    "terraform"
    "terraformer"
    "packer"
    "git-trim"
    "conda"
    "mitmproxy"
    "insomnia"
    "wireshark"
    "jsonnet"
    "zls"
    "verible"
    "gdb"
    "ncdu"
    "racket-minimal"
  ];
in {
  nixpkgs.overlays = [
    (
      _: super: let
        removeUnwantedPackages = pname: lib.warn "the ${pname} has been removed on the darwin platform" super.emptyDirectory;
      in
        lib.genAttrs brokenPackages removeUnwantedPackages
    )
    (_: super: {
      # direnv's fish tests are currently unstable on Darwin and get killed mid-build.
      direnv = super.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
