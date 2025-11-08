# https://github.com/NixOS/nixpkgs/issues/456347
_: (_: super: {
  sbcl = super.sbcl.overrideAttrs (old: {
    doCheck = false;
  });
})
